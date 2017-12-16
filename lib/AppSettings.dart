import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Opens an [AlertDialog] showing what the user typed.
class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettingsState createState() => new _AppSettingsState();
}

/// State for [AppSettings] widgets.
class _AppSettingsState extends State<AppSettings> {
  final TextEditingController _urlController = new TextEditingController();
  final TextEditingController _tokenController = new TextEditingController();
  String _accessToken;
  String _url;

  @override
  void initState() async {
    await this._getSharedPreferences();
  }

  _getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _url = prefs.getString("url");
      _accessToken = prefs.getString("token");
    });
    print("get url = ${_url}");
    print("get token = ${_accessToken}");
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
        actions: <Widget>[
	  new FlatButton(
	    child: new Row(
	      children: <Widget>[
	        new Icon(Icons.favorite, color: Colors.red),
	        new Text("100", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
	    ])
	  ),
        ]
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
		  showDialog(
		    context: context,
		    child: new AlertDialog(
		      title: new Text('Preferences confirmed'),
		      content: new Text("url = ${_urlController.text}, access token = ${_accessToken}"),
		    ),
		  );
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
