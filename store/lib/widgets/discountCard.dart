import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/models/cartModel.dart';

class DiscountCard extends StatefulWidget {
  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o cupom'
                ),
                initialValue: CartModel.of(context).couponCode ?? '',
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Insira o cupom';
                  }
                },
                onFieldSubmitted: (text) {
                  if (_formKey.currentState.validate()) {
                    Firestore.instance
                      .collection('coupons')
                      .document(text)
                      .get()
                      .then((document) {
                        if (document.data != null) {
                          CartModel.of(context).setCoupon(text, document.data['percent']);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Desconto de ${document.data["percent"]}% aplicado!'),
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                          );
                        } else {
                          CartModel.of(context).setCoupon(null, 0);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cupom inválido!'),
                              backgroundColor: Colors.redAccent,
                            )
                          );
                        }
                      });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
