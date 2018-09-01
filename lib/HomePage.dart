import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/RewardsPage.dart';
import 'package:quiznoob/QuizListItem.dart';
import 'package:quiznoob/model/Quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage(this.title, this.root);

  final String title;
  final SubjectPageState root;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List<Quiz> quizzes = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() {
    this.getSharedPreferences();
  }

  Future<Null> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
    this.getData();
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/quizzes.json"),
      body: widget.title == "All Quizzes" ? {"access_token": _accessToken} : {"access_token": _accessToken, "subject": widget.title},
      headers: {
        "Accept":"application/json"
	}
    );
    if(response.statusCode == 200) {
      this.setState(() {
         quizzes.clear();
	 Map map = json.decode(response.body);
         List l = map["quizzes"];
         l.forEach((m) {
	   Quiz q = new Quiz(m["id"].toInt(), m["name"], m["description"], m["numquestions"], m["points"].toInt());
	   q.unattempted = new List<int>();
	   m["unattempted"].forEach((n) {
	     q.unattempted.add(n);
	   });
           quizzes.add(q);
         });
	 _hearts = map["hearts"];
      });
    }
  }

  SubjectPageState getRoot() {
    return widget.root;
  }

  addHearts(int points) {
    this.setState(() {
      _hearts += points;
      widget.root.setHearts(_hearts);
    });
  }

  setHearts(int points) {
    this.setState(() {
      _hearts = points;
      widget.root.setHearts(points);
    });
  }

  int getHearts() {
    return _hearts;
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) {  });
  }

  @override
  Widget build(BuildContext context) {
    if(quizzes.length > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
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
	        Navigator.push(context, new MaterialPageRoute(
		  builder: (BuildContext context) => new RewardsPage(widget.root),
		  ));
              }),
	    ),
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: quizzes.map((Quiz quiz) {
	      return new QuizListItem(quiz,this);
	    }).toList()
          )
        )
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Icon(Icons.favorite),
	        new Text("Sorry, no '${widget.title}' quizzes!"),
	      ]
            )
          )
        )
      );
    }
  }
}

