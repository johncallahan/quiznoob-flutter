import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuestionListItem.dart';
import 'package:quizcircle/model/Question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  QuestionPageState createState() => new QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {

  List<Question> questions = new List();
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
      Uri.encodeFull("${_url}/api/questions.json"),
          body: {"access_token": _accessToken, "quiz": "1"},
        headers: {
          "Accept":"application/json"
	}
      );
      this.setState(() {
         questions.clear();
         List l = JSON.decode(response.body);
         l.forEach((map) {
	   print("processing");
           questions.add(new Question(map["id"].toInt(), map["name"], map["description"]));
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
    print("number of '${widget.title}' questions = ${questions.length}");
    if(questions.length > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: questions.map((Question question) {
	      return new QuestionListItem(question);
	    }).toList()
          )
        )
      );
    } else {
      print("no questions");
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
	        new Text("Sorry, no '${widget.title}' questions!"),
	      ]
            )
          )
        )
      );
    }
  }
}

