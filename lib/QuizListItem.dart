import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizcircle/model/Quiz.dart';

class QuizListItem extends StatelessWidget {
  final Quiz quiz;

  QuizListItem(this.quiz);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new Column(children: [
              new Text(
                quiz.name,
                textScaleFactor: 0.9,
                textAlign: TextAlign.left,
              ),
              new Text(
                quiz.description,
                textScaleFactor: 0.8,
                textAlign: TextAlign.right,
                style: new TextStyle(
                  color: Colors.grey,
                ),
              ),
            ], crossAxisAlignment: CrossAxisAlignment.start)),
        new Expanded(
            child: new Text(
              "XX",
              textScaleFactor: 2.0,
              textAlign: TextAlign.center,
            )),
        new Expanded(
            child: new Text(
              "YY",
              textScaleFactor: 1.6,
              textAlign: TextAlign.right,
            )),
      ]),
    );
  }
}
