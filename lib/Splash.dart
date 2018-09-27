import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/AppSettings.dart';
import 'package:quiznoob/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  String _accessToken = null;
  String _url = null;
  User _user = null;

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
    this.getData();
  }

  Future<Null> getData() async {
    if(_url != null) {
      http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/user.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
      if(response.statusCode == 200) {
        this.setState(() {
           Map map = json.decode(response.body);
  	 _user = new User(map["id"].toInt(), map["name"], map["hearts"].toInt());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_user != null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Welcome!"),
	  backgroundColor: Colors.green,
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
                    Navigator.pushReplacement(context, new MaterialPageRoute(
		      builder: (BuildContext context) => new Subjects(),
		    ));
		  }
                ),
	        new Text("Welcome ${_user.name}!",
		  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)
		),
		new Text("(click the heart to continue)")
	      ]
            )
          )
        )
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Welcome!"),
	  backgroundColor: Colors.green,
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
                    Navigator.pushReplacement(context, new MaterialPageRoute(
		      builder: (BuildContext context) => new AppSettings(),
		    ));
		  }
                ),
	        new Text("Welcome!"),
		new Text("(click the heart to continue)")
	      ]
            )
          )
        )
      );
    }
  }
}
