import 'package:flutter/material.dart';

class Congrats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Congrats!"),
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
        child: new Center(
          child: new Column(
	    mainAxisAlignment: MainAxisAlignment.center,
	    children: <Widget>[
	      new IconButton(
	        icon: new Icon(Icons.favorite, color: Colors.red),
		iconSize: 70.0,
		onPressed: () {
                  Navigator.pop(context);
		}
              ),
	      new Text("Congrats!"),
	    ]
          ))));
  }
}

