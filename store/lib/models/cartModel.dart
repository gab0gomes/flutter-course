import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/datas/cartProduct.dart';
import 'package:store/models/userModel.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  bool isLoading = false;

  int discountPercentage = 0;
  String couponCode;

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance.collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .add(cartProduct.toMap())
      .then((document) {
        cartProduct.cartId = document.documentID;
      });

      notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance.collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .document(cartProduct.cartId)
      .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decreaseQuantity(CartProduct cartProduct) {
    cartProduct.quantity--;

    Firestore.instance.collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .document(cartProduct.cartId)
      .updateData(cartProduct.toMap());

      notifyListeners();
  }

  void increaseQuantity(CartProduct cartProduct) {
    cartProduct.quantity++;

    Firestore.instance.collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .document(cartProduct.cartId)
      .updateData(cartProduct.toMap());

      notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
      .collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .getDocuments();

    products = query.documents.map((document) => CartProduct.fromDocument(document)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct product in products) {
      if (product.productData != null) {
        price += product.quantity * product.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance
      .collection('orders')
      .add({
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productsPrice,
        'discount': discount,
        'totalPrice': productsPrice - discount + shipPrice,
        'status': 1
      });

    await Firestore.instance
      .collection('users')
      .document(user.firebaseUser.uid)
      .collection('orders')
      .document(refOrder.documentID)
      .setData({
        'orderId': refOrder.documentID,
      });

    QuerySnapshot query = await Firestore.instance
      .collection('users')
      .document(user.firebaseUser.uid)
      .collection('cart')
      .getDocuments();

    for (DocumentSnapshot document in query.documents) {
      document.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }
}