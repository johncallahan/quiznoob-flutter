import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/SubjectsListItem.dart';
import 'package:quizcircle/RewardsPage.dart';
import 'package:quizcircle/AppSettings.dart';
import 'package:quizcircle/model/Subject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subjects extends StatefulWidget {
  @override
  SubjectPageState createState() => new SubjectPageState();
}

class SubjectPageState extends State<Subjects> {

  List<Subject> subjects = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() async {
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
    await this.getSharedPreferences();
    this.setState(() {
      subjects.clear();
    });
    print("data url = ${_url}");
    print("data token = ${_accessToken}");
    if(_url != null && _accessToken != null) {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/subjects.json"),
      body: {"access_token": _accessToken},
      headers: {
        "Accept":"application/json"
	}
    );
    if (response.statusCode == 200) {
      this.setState(() {
        Map map = JSON.decode(response.body);
	List l = map["subjects"];
	_hearts = map["hearts"];
        l.forEach((m) {
          subjects.add(new Subject(m["id"].toInt(), m["name"], m["numquizzes"].toInt()));
	  });
      });
    }
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    this.getData();
    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) { print("completed refreshing"); });
  }

  setHearts(int points) {
    this.setState(() {
      _hearts = points;
    });
  }

  int getHearts() {
    return _hearts;
  }

  @override
  Widget build(BuildContext context) {
    if(subjects != null && subjects.length > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Subjects"),
	  backgroundColor: Colors.green,
          actions: <Widget>[
	    new FlatButton(
	      child: new Row(
	        children: <Widget>[
	          new Icon(Icons.favorite, color: Colors.red),
	          new Text("${_hearts}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	      ]),
	      onPressed: (() {
	        Navigator.push(context, new MaterialPageRoute(
		  builder: (BuildContext context) => new RewardsPage(this),
		  ));
              }),
	    ),
	    new IconButton(
   	      icon: new Icon(Icons.settings),
	      tooltip: 'Settings',
	      onPressed: () {
	        Navigator.push(context, new MaterialPageRoute(
	          builder: (BuildContext context) => new AppSettings(),
                ));
	      }
            )
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: subjects.map((Subject subject) {
	      return new SubjectsListItem(subject, this);
	    }).toList()
          )
        )
      );
    } else {
      print("no subjects");
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Subjects"),
	  backgroundColor: Colors.green,
          actions: <Widget>[
	    new IconButton(
   	      icon: new Icon(Icons.settings),
	      tooltip: 'Settings',
	      onPressed: () {
	        Navigator.push(context, new MaterialPageRoute(
	          builder: (BuildContext context) => new AppSettings(),
                ));
	      }
            )
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: subjects.map((Subject subject) {
	      return new SubjectsListItem(subject, this);
	    }).toList()
          )
        )
      );
    }
  }
}
