import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuestionListItem.dart';
import 'package:quizcircle/model/Quiz.dart';
import 'package:quizcircle/model/Answer.dart';
import 'package:quizcircle/model/Question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  QuestionPage(this.quiz);

  final Quiz quiz;

  @override
  QuestionPageState createState() => new QuestionPageState();
}

class QuestionPageState extends State<QuestionPage> {

  Question question;
  List answers;
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
      Uri.encodeFull("${_url}/api/questions/${widget.quiz.unattempted[0]}.json"),
          body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
    this.setState(() {
      Map map = JSON.decode(response.body);
      question = new Question(map["id"].toInt(),map["name"]);
      answers = new List();
      map["answers"].forEach((answer) {
        answers.add(new Answer(answer["id"].toInt(),answer["name"],Colors.blue));
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
    if(question != null) {
      print("the question is ${question.name} with no answers");
      List<Widget> answerButtons = new List<Widget>();
      
      int i = 0;
      answers.forEach((answer) {
        answerButtons.add(new Container(
	  margin: const EdgeInsets.all(4.0),
	  child: new RaisedButton(
            child: new Text(answer.name, style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0)),
	    color: answer.color,
	    onPressed: () { print(answer.name); setState(() { answers.forEach((a) {a.color = Colors.grey;}); answer.color = Colors.green; }); } )));
	i = i + 1;
      });

      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Container(
		  margin: const EdgeInsets.all(50.0),
	          child: new Text(
		    question.name,
		    style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0),
		  ),
                ),
		new Column(
		  children: answerButtons,
		),
		new IconButton(
		  icon: new Icon(Icons.favorite),
		  tooltip: 'Start',
		  iconSize: 70.0,
		  onPressed: () {
		    widget.quiz.unattempted.removeAt(0);
		    Navigator.pushReplacement(context, new MaterialPageRoute(
		      builder: (BuildContext context) => new QuestionPage(widget.quiz),
		    ));
		  }
		),
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
	        new Icon(Icons.access_time),
		new Text("loading ..."),
              ]
	    )
	  )
	)
      );
    }
  }
}
