import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/UserListItem.dart';
import 'package:quiznoob/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OthersWidget extends StatefulWidget {
  OthersWidget({Key key}) : super(key: key);

  @override
  _OthersWidgetState createState() => new _OthersWidgetState();
}

class _OthersWidgetState extends State<OthersWidget> {
  String _accessToken;
  String _url;
  List<User> _users = new List();

  @override
  void initState() {
    if(mounted) {
      this._getSharedPreferences();
    }
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
    http.Response response = await http.post(
      Uri.encodeFull("${_url}/api/users.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
      if(response.statusCode == 200) {
        if(mounted) {
          this.setState(() {
            _users.clear();
            List list = JSON.decode(response.body);
            list.forEach((u) {
              _users.add(new User(u["id"].toInt(), u["name"], u["hearts"].toInt()));
            });
          });
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    if(_users.length != null) {
      return new Container(
        child: new Center(
          child: new ListView(
            children: _users.map((User u) {
              return new UserListItem(u);
            }).toList()
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
                onPressed: () { }
              ),
	      new Text("loading..."),
	    ]
          )
        )
      );
    }
  }

}
