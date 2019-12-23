import 'package:flutter/material.dart';
import 'package:quiznoob/Subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettingsState createState() => new _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final TextEditingController _urlController = new TextEditingController();
  final TextEditingController _tokenController = new TextEditingController();
  String _accessToken;
  String _url;

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
    _urlController.text = _url;
    _tokenController.text = _accessToken;
  }

  _setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("url", _urlController.text);
    prefs.setString("token", _tokenController.text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
	      backgroundColor: Colors.green,
      ),
      body: new Container(
        padding: const EdgeInsets.all(35.0),
        child: new Center(
          child: new Column(
	          mainAxisAlignment: MainAxisAlignment.center,
	          children: <Widget>[
	            new TextField(
	              controller: _urlController,
	              decoration: new InputDecoration(
	                hintText: 'Url',
	              ),
	            ),
	            new TextField(
	              controller: _tokenController,
	              decoration: new InputDecoration(
	                hintText: 'Access token',
	              ),
	            ),
	            new Text("    "),
	            new Text("    "),
	            new RaisedButton(
	              onPressed: () {
		              _setSharedPreferences();
                  Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (BuildContext context) => new Subjects()
                  ));
		            },
	            	child: new Text('DONE'),
	            ),
            ],
          )
	      )
      )
    );
  }
}
