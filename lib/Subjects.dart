import 'package:flutter/material.dart';
import 'package:quizcircle/HomePage.dart';
import 'package:quizcircle/AppSettings.dart';

final List<String> subjects = <String>[
  "All Quizzes",
  "Mathematics",
  "Geography",
  "World History",
  "US History",
  "Science",
  "English",
  "Chemistry",
  "Physics",
  "Astronomy",
  "Biology",
];

class SubjectListItem extends StatelessWidget {
  final String title;

  SubjectListItem(this.title);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new ListTile(
              title: new Text(title,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
              trailing: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
	      onTap: () {
	        Navigator.push(context, new MaterialPageRoute(
		  builder: (BuildContext context) => new HomePage(title: title),
		));
              }
            ))
      ]),
    );
  }
}

class Subjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Subjects"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          new IconButton(
   	    icon: new Icon(Icons.settings),
	    tooltip: 'Settings',
	    onPressed: () {
	      Navigator.push(context, new MaterialPageRoute(
	        builder: (BuildContext context) => new AppSettings(),
              ));
	    }
          )
        ]),
      body: new ListView(
	  children: subjects.map((String subject) {
	    return new SubjectListItem(subject);
	  }).toList()
      )
    );
  }
}
