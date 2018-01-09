import 'package:flutter/material.dart';
import 'package:quizcircle/HomePage.dart';
import 'package:quizcircle/model/Redemption.dart';

class RedemptionListItem extends StatelessWidget {
  final Redemption redemption;

  RedemptionListItem(this.redemption);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Row(children: [
        new Expanded(
            child: new ListTile(
              title: new Text(redemption.name,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              subtitle: new Text(redemption.created_at,
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
              trailing: new Text("${redemption.cost}",
                  style: new TextStyle(fontWeight: FontWeight.w500)),
	      onTap: () {
              }
	    ))
	  ]
	));
  }
}
