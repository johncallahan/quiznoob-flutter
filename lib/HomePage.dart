import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuizListItem.dart';
import 'package:quizcircle/model/Quiz.dart';

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

  @override
  void initState() {
    this.getData();
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("https://quiz.zrails.com/api/quizzes.json"),
        body: {"access_token": "4TG-5ZkpdiXELv_-kLqgPA"},
        headers: {
          "Accept":"application/json"
	}
      );
      this.setState(() {
         quizzes.clear();
         List l = JSON.decode(response.body);
         l.forEach((map) {
	   print("processing");
           quizzes.add(new Quiz(map["id"].toInt(), map["name"], map["description"]));
         });
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Quiz Circle"),
	actions: <Widget>[
	  new IconButton(
	    icon: new Icon(Icons.settings),
	    tooltip: 'Settings',
	    onPressed: () { Navigator.of(context).pushNamed("/settings");}
	  )
	]
      ),
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
	child: new ListView(
	children: quizzes.map((Quiz quiz) {
	  return new QuizListItem(quiz);
	}).toList()
      ))
    );
  }

}
