import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/models/cartModel.dart';
import 'package:store/models/userModel.dart';
import 'package:store/screens/loginScreen.dart';
import 'package:store/screens/orderConfirmationScreen.dart';
import 'package:store/tiles/cartTile.dart';
import 'package:store/widgets/cartPrice.dart';
import 'package:store/widgets/discountCard.dart';
import 'package:store/widgets/shipCard.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu carrinho'),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int quantity = model.products.length;
                return Text(
                  '${quantity ?? 0} ${quantity == 1 ? "ITEM" : "ITENS"}',
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16.0,),
                  Text(
                    'Faça o login para adicionar produtos',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                'Carrinho vazio!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product) => CartTile(product)).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrderConfirmationScreen(orderId))
                    );
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}