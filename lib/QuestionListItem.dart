import 'package:flutter/material.dart';
import 'package:quizcircle/model/Question.dart';

class QuestionListItem extends StatelessWidget {
  final Question question;

  QuestionListItem(this.question);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new ListTile(
              title: new Text(question.name,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
              trailing: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
	      onTap: () { print("tapped ${question.id}"); }
            ))
      ]),
    );
  }
}
