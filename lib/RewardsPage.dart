import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/Subjects.dart';
import 'package:quizcircle/RewardsListItem.dart';
import 'package:quizcircle/model/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsPage extends StatefulWidget {
  RewardsPage(this.root);

  final SubjectPageState root;

  @override
  RewardsPageState createState() => new RewardsPageState();
}

class RewardsPageState extends State<RewardsPage> {

  List<Reward> rewards = new List();
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
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/rewards.json"),
      body: {"access_token": _accessToken},
      headers: {
        "Accept":"application/json"
      }
    );
    this.setState(() {
      rewards.clear();
      Map map = JSON.decode(response.body);
      List l = map["rewards"];
      this.setHearts(map["hearts"]);
      l.forEach((m) {
        rewards.add(new Reward(m["id"].toInt(), m["name"], m["cost"].toInt(), m["description"]));
      });
    });
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
    widget.root.setHearts(points);
  }

  int getHearts() {
    return widget.root.getHearts();
  }

  @override
  Widget build(BuildContext context) {
    if(rewards.length > 0) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Rewards"),
	  backgroundColor: Colors.green,
          actions: <Widget>[
	    new FlatButton(
	      child: new Row(
	        children: <Widget>[
	          new Icon(Icons.favorite, color: Colors.red),
	          new Text("${_hearts}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	      ])
	    ),
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: new ListView(
            children: rewards.map((Reward reward) {
	      return new RewardsListItem(reward,this);
	    }).toList()
          )
        )
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Rewards"),
        ),
        body: new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Icon(Icons.favorite),
	        new Text("Sorry, no rewards yet!"),
	      ]
            )
          )
        )
      );
    }
  }
}
