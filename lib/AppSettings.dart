import 'package:flutter/material.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings"), backgroundColor: Colors.red),
      body: new Container(
        child: new Center(
	  child: new Column(
	    mainAxisAlignment: MainAxisAlignment.center,
	    children: <Widget>[
	      new IconButton(
	        icon: new Icon(Icons.home, color: Colors.blue),
		iconSize: 70.0,
		onPressed: null
	      ),
	      new Text("Home")
	    ]
	  ),
	),
      ),
    );
  }
}
