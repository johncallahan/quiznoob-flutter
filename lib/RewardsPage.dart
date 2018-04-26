import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/ProfileWidget.dart';
import 'package:quiznoob/OthersWidget.dart';
import 'package:quiznoob/RewardsListItem.dart';
import 'package:quiznoob/model/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsPage extends StatefulWidget {
  RewardsPage(this.root);

  final SubjectPageState root;

  @override
  RewardsPageState createState() => new RewardsPageState();
}

class RewardsPageState extends State<RewardsPage> {

  List<Reward> rewards = new List();
  String _accessToken;
  String _url;
  int _hearts;

  @override
  void initState() {
    if(mounted) {
      this.getSharedPreferences();
    }
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
      return new MaterialApp(
        home: new DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: new AppBar(
              title: new Text("Profile"),
              backgroundColor: Colors.green,
	      leading: new IconButton(
                icon: new BackButtonIcon(),
                onPressed: () {
		  Navigator.pop(context);
                  Navigator.pushReplacement(context, new MaterialPageRoute(
	            builder: (BuildContext context) => new Subjects(),
                  ));
		}
	      ),
              actions: <Widget>[
                new FlatButton(
                  child: new Row(
	          children: <Widget>[
	            new Icon(Icons.favorite, color: Colors.red),
	            new Text("${_hearts}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	          ])
	        ),
              ],
	      bottom: new TabBar(
                tabs: [
	          new Tab(text: "Rewards", icon: new Icon(Icons.favorite)),
	          new Tab(text: "You", icon: new Icon(Icons.person)),
	          new Tab(text: "Others", icon: new Icon(Icons.people)),
	        ]
	      ),
            ),
            body: new TabBarView(
              children: <Widget>[
                new ListView(
                  children: rewards.map((Reward reward) {
                    return new RewardsListItem(reward,this);
                  }).toList()
                ),
		new ProfileWidget(),
		new OthersWidget(),
              ]
            ),
          ),
        ),
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
