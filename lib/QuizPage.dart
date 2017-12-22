import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/HomePage.dart';
import 'package:quizcircle/RewardsPage.dart';
import 'package:quizcircle/QuestionPage.dart';
import 'package:quizcircle/QuestionListItem.dart';
import 'package:quizcircle/model/Quiz.dart';
import 'package:quizcircle/model/Question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  QuizPage(this.quiz, this.home);

  final Quiz quiz;
  final HomePageState home;

  @override
  QuizPageState createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Quiz quiz;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  int _hearts;

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
         Map map = JSON.decode(response.body);
	 Quiz quiz = new Quiz(map["id"].toInt(), map["name"], map["description"], map["numquestions"], map["unattempted"], map["points"].toInt());
	 print("quiz NAME is ${quiz.name}");
	 _hearts = map["hearts"];
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
    print("number of ${widget.quiz.name} questions = ${widget.quiz.numquestions}");
    if(widget.quiz.numquestions > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
	  backgroundColor: Colors.green,
          actions: <Widget>[
	    new FlatButton(
	      child: new Row(
	        children: <Widget>[
	          new Icon(Icons.favorite, color: Colors.red),
	          new Text("${_hearts}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	      ]),
	      onPressed: (() {
	        Navigator.pop(context);
	        Navigator.pushReplacement(context, new MaterialPageRoute(
		  builder: (BuildContext context) => new RewardsPage(widget.home.getRoot()),
		  ));
              }),
	    ),
          ]
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new IconButton(
		  icon: new Icon(Icons.directions_run),
		  tooltip: 'Start',
		  iconSize: 70.0,
		  onPressed: () {
		    Navigator.pushReplacement(context, new MaterialPageRoute(
		      builder: (BuildContext context) => new QuestionPage(widget.quiz, widget.home),
		    ));
		  }
		),
	        new Text("${widget.quiz.unattempted.length}/${widget.quiz.numquestions} questions left"),
	        new Text("Click icon to start the quiz!"),
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
  }
}
