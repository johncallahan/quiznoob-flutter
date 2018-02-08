import 'package:flutter/material.dart';
import 'package:quiznoob/HomePage.dart';
import 'package:quiznoob/model/User.dart';

class UserListItem extends StatelessWidget {
  final User user;

  UserListItem(this.user);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new ListTile(
              title: new Text(user.name,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
              trailing: new Text("${user.hearts}",
                  style: new TextStyle(fontWeight: FontWeight.w500)),
	      onTap: () {
              }
	    ))
	  ]
	));
  }
}



