import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Person counter',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _statusText = 'Pode entrar!';

  void _changePeople(int step) {
    setState(() {
      _people += step;

      if (_people < 0) {
        _statusText = 'Mundo invertido!';
      } else if (_people <= 10) {
        _statusText = 'Pode entrar!';
      } else {
        _statusText = 'Lotado!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/restaurant.jpg',
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Pessoas: $_people',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            '+1',
                            style:
                                TextStyle(color: Colors.white, fontSize: 40.0),
                          ),
                          highlightColor: Colors.white,
                          onPressed: () {
                            _changePeople(1);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text('-1',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40.0)),
                          highlightColor: Colors.white,
                          onPressed: () {
                            _changePeople(-1);
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 30.0,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
