import 'package:flutter/material.dart';
import 'package:quizcircle/HomePage.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Quiz Circle',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(title: 'Quiz Circle'),
    );
  }
}
