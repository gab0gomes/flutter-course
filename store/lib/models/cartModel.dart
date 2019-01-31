import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/datas/cartProduct.dart';
import 'package:store/datas/productData.dart';
import 'package:store/models/userModel.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user);

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
}