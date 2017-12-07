import 'package:flutter/material.dart';
import 'package:quizcircle/HomePage.dart';
import 'package:quizcircle/Subjects.dart';
import 'package:quizcircle/AppSettings.dart';
import 'package:quizcircle/QuizPage.dart';
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
      title: 'Quiz Circle',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Subjects(),
      routes: <String, WidgetBuilder> {
        "/settings": (BuildContext context) => new AppSettings(),
        "/All Quizzes": (BuildContext context) => new HomePage(title: "All Quizzes"),
        "/Mathematics": (BuildContext context) => new HomePage(title: "Mathematics"),
        "/Geography": (BuildContext context) => new HomePage(title: "Geography"),
        "/World History": (BuildContext context) => new HomePage(title: "World History"),
        "/US History": (BuildContext context) => new HomePage(title: "US History"),
        "/Science": (BuildContext context) => new HomePage(title: "Science"),
        "/English": (BuildContext context) => new HomePage(title: "English"),
        "/Chemistry": (BuildContext context) => new HomePage(title: "Chemistry"),
        "/Physics": (BuildContext context) => new HomePage(title: "Physics"),
        "/Astronomy": (BuildContext context) => new HomePage(title: "Astronomy"),
        "/Biology": (BuildContext context) => new HomePage(title: "Biology"),
	"/quiz": (BuildContext context) => new QuizPage(title: "Quiz"),
      }
    );
  }
}
