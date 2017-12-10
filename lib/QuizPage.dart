import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuestionListItem.dart';
import 'package:quizcircle/model/Quiz.dart';
import 'package:quizcircle/model/Question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  QuizPage(this.quiz);

  final Quiz quiz;

  @override
  QuizPageState createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Map quiz = new Map();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;

  @override
  void initState() async {
    await this.getSharedPreferences();
    this.getData();
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
    print("get url = ${_url}");
    print("get token = ${_accessToken}");
  }

  Future<Null> getData() async {
    print("data url = ${_url}");
    print("data token = ${_accessToken}");
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/quizzes/${widget.quiz.id}.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
      this.setState(() {
         quiz = JSON.decode(response.body);
	 print("quiz is ${quiz['name']}");
      });
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) { print("completed refreshing"); });
  }

  @override
  Widget build(BuildContext context) {
    if(quiz['name'] != null) {
    print("number of ${quiz['name']} questions = ${quiz['numquestions']}");
    if(quiz['numquestions'] > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Icon(Icons.favorite),
	        new Text("${quiz['numquestions']} questions!"),
	      ]
            )
          )
        )
      );
    } else {
      print("no questions");
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Icon(Icons.favorite),
	        new Text("Sorry, no questions!"),
	      ]
            )
          )
        )
      );
    }
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Icon(Icons.favorite),
	        new Text("loading ...!"),
	      ]
            )
          )
        )
      );
    }
  }
}

