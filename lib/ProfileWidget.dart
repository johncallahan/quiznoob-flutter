import 'package:flutter/material.dart';
import 'package:quizcircle/Subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => new _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String _accessToken;
  String _url;

  @override
  void initState() async {
    if(mounted) {
      await this._getSharedPreferences();
    }
  }

  _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Text("For you...");
  }

}
