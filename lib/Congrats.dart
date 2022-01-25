import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/HomePage.dart';
import 'package:quiznoob/model/Quiz.dart';
import 'package:quiznoob/model/Bonus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Congrats extends StatefulWidget {
  Congrats(this.quiz, this.home);

  final Quiz quiz;
  final HomePageState home;

  @override
  _CongratsState createState() => new _CongratsState();
}

class _CongratsState extends State<Congrats> {
  String _accessToken;
  String _url;
  Bonus _bonus;

  @override
  void initState() {
    this._getSharedPreferences();
  }

  _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
  }

  Future<Null> _collectBonus() async {
    http.Response response = await http.post(
      Uri.parse("${_url}/api/bonuses.json"),
          body: {"access_token": _accessToken, "quiz_id": widget.quiz.id.toString()},
        headers: {
          "Accept":"application/json"
	}
      );
    this.setState(() {
      Map map = json.decode(response.body);
      _bonus = new Bonus(map["id"].toInt());
      widget.home.addHearts(widget.quiz.points);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Congrats!"),
	backgroundColor: Colors.green,
        actions: <Widget>[
	  new FlatButton(
	    child: new Row(
	      children: <Widget>[
	        new Icon(Icons.favorite, color: Colors.red),
	        new Text("${widget.home.getHearts()}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	    ])
	  ),
        ]
      ),
      body: new Container(
        child: new Center(
          child: new Column(
	    mainAxisAlignment: MainAxisAlignment.center,
	    children: <Widget>[
	      new IconButton(
	        icon: new Icon(Icons.favorite, color: Colors.red),
		iconSize: 70.0,
		onPressed: () {
		  _collectBonus();
                  Navigator.pop(context);
		}
              ),
	      new Text("Congrats on the ${widget.quiz.name} quiz!"),
	      new Text("You've earned ${widget.quiz.points} bonus points!"),
	    ]
          )
        )
      )
    );
  }
}
