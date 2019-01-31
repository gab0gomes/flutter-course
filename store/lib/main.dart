import 'package:flutter/material.dart';
import 'package:store/models/cartModel.dart';
import 'package:store/models/userModel.dart';
import 'package:store/screens/homeScreen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Home',
              theme: ThemeData(
                primaryColor: Color.fromARGB(255, 4, 125, 141),
                primarySwatch: Colors.blue,
              ),
              home: HomeScreen(),
            ),
          );
        },
      )
    );
  }
}