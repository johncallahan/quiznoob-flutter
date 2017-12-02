import 'package:flutter/material.dart';

/// Opens an [AlertDialog] showing what the user typed.
class AppSettings extends StatefulWidget {
  AppSettings({Key key}) : super(key: key);

  @override
  _AppSettingsState createState() => new _AppSettingsState();
}

/// State for [AppSettings] widgets.
class _AppSettingsState extends State<AppSettings> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings"), backgroundColor: Colors.red),
      body: new Container(
        child: new Center(
          child: new Column(
	    mainAxisAlignment: MainAxisAlignment.center,
	    children: <Widget>[
	      new TextField(
	        controller: _controller,
	        decoration: new InputDecoration(
	          hintText: 'Type something',
	        ),
	      ),
	      new RaisedButton(
	        onPressed: () {
		  showDialog(
		    context: context,
		    child: new AlertDialog(
		      title: new Text('What you typed'),
		      content: new Text(_controller.text),
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
