import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuizListItem.dart';
import 'package:quizcircle/model/Quiz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List<Quiz> quizzes = new List();
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
      Uri.encodeFull("${_url}/api/quizzes.json"),
      body: widget.title == "All Quizzes" ? {"access_token": _accessToken} : {"access_token": _accessToken, "subject": widget.title},
      headers: {
        "Accept":"application/json"
	}
    );
    if(response.statusCode == 200) {
      this.setState(() {
         quizzes.clear();
         List l = JSON.decode(response.body);
         l.forEach((map) {
	   print("processing");
           quizzes.add(new Quiz(map["id"].toInt(), map["name"], map["description"], map["numquestions"], map["unattempted"]));
         });
      });
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) { print("completed refreshing"); });
  }

  @override
  Widget build(BuildContext context) {
    print("number of '${widget.title}' quizzes = ${quizzes.length}");
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
	          new Text("100", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	      ])
	    ),
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: quizzes.map((Quiz quiz) {
	      return new QuizListItem(quiz);
	    }).toList()
          )
        )
      );
    } else {
      print("no quizzes");
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

