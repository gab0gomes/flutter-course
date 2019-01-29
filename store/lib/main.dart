import 'package:flutter/material.dart';
import 'package:store/screens/homeScreen.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 4, 125, 141),
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}