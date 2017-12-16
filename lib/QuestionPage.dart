import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/Congrats.dart';
import 'package:quizcircle/QuestionListItem.dart';
import 'package:quizcircle/model/Quiz.dart';
import 'package:quizcircle/model/Answer.dart';
import 'package:quizcircle/model/Question.dart';
import 'package:quizcircle/model/Attempt.dart';
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
  bool visibility = false;
  Answer guess = null;
  Attempt _attempt = null;

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
      question = new Question(map["id"].toInt(), map["name"], map["answer_id"].toInt());
      answers = new List();
      map["answers"].forEach((answer) {
        answers.add(new Answer(answer["id"].toInt(),answer["name"],Colors.blue));
      });
    });
  }

  Future<Null> _makeAttempt() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/attempts.json"),
          body: {"access_token": _accessToken, "quiz_id": widget.quiz.id.toString(), "question_id": question.id.toString(), "answer_id": guess.id.toString()},
        headers: {
          "Accept":"application/json"
	}
      );
    this.setState(() {
      Map map = JSON.decode(response.body);
      _attempt = new Attempt(map["id"].toInt(),map["result"],map["answer_id"]);
      answers.forEach((a) {
	if(a.id == question.answer_id) {
	  a.color = Colors.green;
	} else if(a.id == guess.id) {
	  a.color = Colors.red;
	}
      });
    });
  }

  _handleAnswered(Answer answer) {
    print(answer.name);
    if(_attempt == null) {
      setState(() {
        guess = answer;
        answers.forEach((a) {
          a.color = Colors.grey;
        });
        answer.color = Colors.purple;
      });
    }
    visibility = true; 
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
	    onPressed: () { _handleAnswered(answer); } )));
	i = i + 1;
      });

      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.quiz.name),
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
		visibility && _attempt != null && _attempt.result ? new Column(
		  children: <Widget>[
		    new IconButton(
		      icon: new Icon(Icons.sentiment_very_satisfied),
		      tooltip: 'Correct answer!',
		      iconSize: 70.0,
		      onPressed: () {
		        widget.quiz.unattempted.removeAt(0);
			if(widget.quiz.unattempted.length > 0) {
                          Navigator.pushReplacement(context, new MaterialPageRoute(
			    builder: (BuildContext context) => new QuestionPage(widget.quiz),
			    ));
			} else {
                          Navigator.pushReplacement(context, new MaterialPageRoute(
			    builder: (BuildContext context) => new Congrats(),
			    ));
			}
			}),
                    new Text("Correct answer!"),
                    new Text("(click to go to the next question)")]
		) : visibility && _attempt != null ? new Column(
		  children: <Widget>[
		    new IconButton(
		      icon: new Icon(Icons.sentiment_very_dissatisfied),
		      tooltip: 'Sorry, wrong answer',
		      iconSize: 70.0,
		      onPressed: () {
		        widget.quiz.unattempted.removeAt(0);
			if(widget.quiz.unattempted.length > 0) {
                          Navigator.pushReplacement(context, new MaterialPageRoute(
			    builder: (BuildContext context) => new QuestionPage(widget.quiz),
			    ));
			} else {
                          Navigator.pushReplacement(context, new MaterialPageRoute(
			    builder: (BuildContext context) => new Congrats(),
			    ));
			}
			}),
                    new Text("Sorry, wrong answer!"),
                    new Text("(click to go to the next question)")]
		) : visibility ? new Column(
		  children: <Widget>[
		    new IconButton(
		      icon: new Icon(Icons.check_circle),
		      tooltip: 'Check my answer, please',
		      iconSize: 70.0,
		      onPressed: () {
		        _makeAttempt();
		        }),
                    new Text("Click to check your answer"),
                    new Text("===")]
		) : new Column(
		  children: <Widget>[
		    new IconButton(
		      icon: new Icon(Icons.help),
		      tooltip: 'Answer the question, please',
		      iconSize: 70.0
		      ),
                    new Text("==="),
                    new Text("===")]
		)
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
