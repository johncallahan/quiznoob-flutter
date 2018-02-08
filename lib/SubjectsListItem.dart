import 'package:flutter/material.dart';
import 'package:quiznoob/HomePage.dart';
import 'package:quiznoob/Subjects.dart';
import 'package:quiznoob/model/Subject.dart';

class SubjectsListItem extends StatelessWidget {
  final Subject subject;
  final SubjectPageState root;

  SubjectsListItem(this.subject,this.root);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new ListTile(
              title: new Text(subject.name,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              subtitle: new Text(subject.description,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
              trailing: new Text("${subject.numquizzes}",
                  style: new TextStyle(fontWeight: FontWeight.w500)),
	      onTap: () {
	        Navigator.push(context, new MaterialPageRoute(
		  builder: (BuildContext context) => new HomePage(subject.name,root),
		));
              }
	    ))
	  ]
	));
  }
}



