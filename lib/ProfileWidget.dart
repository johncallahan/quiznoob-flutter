import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/Subjects.dart';
import 'package:quizcircle/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => new _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String _accessToken;
  String _url;
  User _user = null;

  @override
  void initState() async {
    if(mounted) {
      await this._getSharedPreferences();
      await new Future<Null>.delayed(new Duration(milliseconds: 1000));
      if(_url != null && _accessToken != null) {
        this.getData();
      }
    }
  }

  _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
  }

  Future<Null> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/user.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
      if(response.statusCode == 200) {
        this.setState(() {
           Map map = JSON.decode(response.body);
  	 _user = new User(map["id"].toInt(), map["name"], map["hearts"].toInt());
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    if(_user != null) {
      return new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new Text("Hello ${_user.name}!",
                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
	        new Stack(
                  alignment: const Alignment(0.0, 0.0),
                  children: <Widget>[
                    new IconButton(
	              icon: new Icon(Icons.favorite, color: Colors.red),
		      iconSize: 140.0,
		      onPressed: () {
		      }
                    ),
                    new Container(
                      child: new Text("${_user.hearts}",style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0))
                    ),
                  ]
                ),
	        new Text("You have ${_user.hearts} hearts",
                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
	      ]
            )
          )
        );
    } else {
      return new Container(
          child: new Center(
            child: new Column(
	      mainAxisAlignment: MainAxisAlignment.center,
	      children: <Widget>[
	        new IconButton(
	          icon: new Icon(Icons.favorite, color: Colors.red),
		  iconSize: 70.0,
		  onPressed: () {
		  }
                ),
	        new Text("loading..."),
	      ]
            )
          )
        );
    }
  }

}
