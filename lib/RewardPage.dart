import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/RewardsPage.dart';
import 'package:quizcircle/model/Reward.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardPage extends StatefulWidget {
  RewardPage(this.reward, this.rewards);

  Reward reward;
  RewardsPageState rewards;

  @override
  RewardPageState createState() => new RewardPageState();
}

class RewardPageState extends State<RewardPage> {

  Reward reward;
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
      Uri.encodeFull("${_url}/api/rewards/${widget.reward.id}.json"),
      body: {"access_token": _accessToken},
      headers: {
        "Accept":"application/json"
	}	
    );
    this.setState(() {
      Map map = JSON.decode(response.body);
      reward = new Reward(map["id"].toInt(), map["name"], map["cost"].toInt(), map["description"]);
    });
  }

  Future<Null> _redeem() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/redemption.json"),
          body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
    this.setState(() {
      Map map = JSON.decode(response.body);
      redemption = new Redemption(map["id"].toInt());
    });
  }

  _handleRedemption(Reward redeem) {

  }

  @override
  Widget build(BuildContext context) {
    if(reward != null) {
      print("the reward is ${reward.name}");

      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.reward.name),
	  backgroundColor: Colors.green,
          actions: <Widget>[
	    new FlatButton(
	      child: new Row(
	        children: <Widget>[
	          new Icon(Icons.favorite, color: Colors.red),
	          new Text("${widget.rewards.getHearts()}", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
		    reward.name,
		    style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0),
		  ),
                ),
              ]
	    )
	  )
	)
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.reward.name),
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
