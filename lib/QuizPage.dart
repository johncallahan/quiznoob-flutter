import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/HomePage.dart';
import 'package:quiznoob/RewardsPage.dart';
import 'package:quiznoob/QuestionPage.dart';
import 'package:quiznoob/QuestionListItem.dart';
import 'package:quiznoob/model/Quiz.dart';
import 'package:quiznoob/model/Question.dart';
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
  void initState() {
    this.getSharedPreferences();
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
    this.getData();
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/quizzes/${widget.quiz.id}.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	      }
      );
      this.setState(() {
        Map map = json.decode(response.body);
	      Quiz quiz = new Quiz(map["id"].toInt(), map["name"], map["description"], map["numquestions"], map["points"].toInt());
	      quiz.unattempted = new List<int>();
	      map["unattempted"].forEach((n) {
          quiz.unattempted.add(n);
	      });
	      _hearts = map["hearts"];
      }
    );
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) {  });
  }

  @override
  Widget build(BuildContext context) {
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
	              new Text("Ready...",
		              style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)
		            ),
	              new Text("Set...",
		              style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)
		            ),
	              new Text("Go!",
		              style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)
		            ),
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
