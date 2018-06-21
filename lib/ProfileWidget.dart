import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/model/User.dart';
import 'package:quiznoob/model/Redemption.dart';
import 'package:quiznoob/RedemptionListItem.dart';
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
  List<Redemption> _redemptions = new List();
  VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    if(mounted) {
      this._getSharedPreferences();
      _controller = new VideoPlayerController.network(
//        'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
//	  'https://www.dropbox.com/s/qzup7o2wxnpiqdo/big_buck_bunny_720p_20mb.mp4?raw=1',
	  'https://www.dropbox.com/s/xmalme1banhm9pv/mytestvideo.mp4?raw=1',
      )
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize();
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
      Uri.encodeFull("${_url}/api/user.json"),
        body: {"access_token": _accessToken},
        headers: {
          "Accept":"application/json"
	}
      );
      if(response.statusCode == 200) {
        if(mounted) {
          this.setState(() {
            _redemptions.clear();
            Map map = JSON.decode(response.body);
            _user = new User(map["id"].toInt(), map["name"], map["hearts"].toInt());
            List list = map["redemptions"];
            list.forEach((r) {
              _redemptions.add(new Redemption(r["id"].toInt(),r["name"],r["cost"].toInt(),r["created_at"]));
            });
          });
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    if(_user != null) {
      if(_redemptions.length > 0) {
        return new Container(
          child: new Center(
            child: new ListView(
              children: _redemptions.map((Redemption r) {
                return new RedemptionListItem(r);
              }).toList()
            ),
          )
        );
      } else {
        return new Scaffold(
          body: new Center(
	    child: new Padding(
	      padding: const EdgeInsets.all(10.0),
	      child: new AspectRatio(
	        aspectRatio: 1280 / 720,
		child: new VideoPlayer(_controller),
	      ),
	    ),
          ),
	  floatingActionButton: new FloatingActionButton(
	    onPressed:
              _controller.value.isPlaying ? _controller.pause : _controller.play,
	    child: new Icon(
	      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
      	  ),
    	);

//        return new Container(
//          child: new Center(
//            child: new Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                new Text("Hello ${_user.name}!",
//                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
//                new Stack(
//                  alignment: const Alignment(0.0, 0.0),
//                  children: <Widget>[
//                    new IconButton(
//                      icon: new Icon(Icons.favorite, color: Colors.red),
//                      iconSize: 140.0,
//                      onPressed: () {
//                      }
//                    ),
//                    new Container(
//                      child: new Text("${_user.hearts}",style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0))
//                    ),
//                  ]
//                ),
//                new Text("You have ${_user.hearts} hearts",
//                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
//                new Text("and no redemptions",
//                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
//                new Text("today",
//                  style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22.0)),
//              ]
//            )
//          )
//        );
      }
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
