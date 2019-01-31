import 'package:flutter/material.dart';
import 'package:store/datas/cartProduct.dart';
import 'package:store/datas/productData.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:store/models/cartModel.dart';
import 'package:store/models/userModel.dart';
import 'package:store/screens/loginScreen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String selectedSize;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images
                .map((url) => NetworkImage(url))
                .toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24.0,),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map((size) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size.toString();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(
                            color: selectedSize == size.toString() ?
                              primaryColor :
                              Colors.grey[500],
                            width: 3.0,
                          ),
                        ),
                        width: 50.0,
                        alignment: Alignment.center,
                        child: Text(size.toString()),
                      ),
                    )).toList(),
                  ),
                ),
                SizedBox(height: 36.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      UserModel.of(context).isLoggedIn() ?
                        'Adicionar ao carrinho' :
                        'Entre para comprar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                    onPressed: selectedSize != null ?
                      () {
                        if (UserModel.of(context).isLoggedIn()) {
                          CartProduct cartProduct = CartProduct();
                          cartProduct.size = selectedSize;
                          cartProduct.quantity = 1;
                          cartProduct.productId = product.id;
                          cartProduct.category = product.category;

                          CartModel.of(context).addCartItem(cartProduct);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        }
                      } :
                      null,
                  ),
                ),
                SizedBox(height: 24.0,),
                Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}