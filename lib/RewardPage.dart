import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/RewardsPage.dart';
import 'package:quizcircle/model/Redemption.dart';
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
  int _hearts;
  Redemption redemption;

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
      Uri.encodeFull("${_url}/api/rewards/${widget.reward.id}.json"),
      body: {"access_token": _accessToken},
      headers: {
        "Accept":"application/json"
	}	
    );
    this.setState(() {
      Map map = JSON.decode(response.body);
      reward = new Reward(map["id"].toInt(), map["name"], map["cost"].toInt(), map["description"]);
      _hearts = map["hearts"].toInt();
    });
  }

  Future<Null> _redeem() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/redemptions.json"),
          body: {"access_token": _accessToken, "reward_id": reward.id.toString()},
        headers: {
          "Accept":"application/json"
	}
      );
    if(response.statusCode == 201) {
      this.setState(() {
        Map map = JSON.decode(response.body);
        redemption = new Redemption(map["id"].toInt());
        _hearts = map["hearts"].toInt();
      });
    } else {
      Map map = JSON.decode(response.body);
      print("${map['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if(reward != null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.reward.name),
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
        body: new Container(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Container(
		  margin: const EdgeInsets.all(50.0),
	          child: new IconButton(
                    icon: new Icon(Icons.favorite, color: Colors.red),
                    iconSize: 70.0,
                    onPressed: (() {
                      showDialog<Null>(
		        context: context,
			child: new AlertDialog(
			  title: const Text('Are your sure?'),
			  content: new Text('Spend ${reward.cost} hearts?'),
			  actions: <Widget>[
			    new FlatButton(
			      child: const Text('YES'),
			      onPressed: () { print("BUY IT!"); _redeem(); Navigator.of(context).pop(); }
			    ),
			    new FlatButton(
			      child: const Text('NO'),
			      onPressed: () { print("NOPE, DO NOT BUY!"); Navigator.of(context).pop(); }
			    ),
			  ],
			)
		      );
                    }),
		  ),
                ),
                new Text(reward.name,style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
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
