import 'package:flutter/material.dart';
import 'package:quizcircle/Splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  _saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    _saveValues();
    return new MaterialApp(
      title: 'quiznoob',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Splash(),
    );
  }
}
