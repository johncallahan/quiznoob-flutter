import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizcircle/QuizListItem.dart';
import 'package:quizcircle/model/Quiz.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List data;

  @override
  void initState() {
    this.getData();
  }

  Future<String> getData() async {
    http.Response response = await http.post(
      Uri.encodeFull("https://quiz.zrails.com/api/quizzes.json"),
      body: {"access_token": "4TG-5ZkpdiXELv_-kLqgPA"},
      headers: {
        "Accept":"application/json"
	});
    this.setState(() {
      data = JSON.decode(response.body);
    });
    return "Success!";
  }

  void _handleOptimismChanged(bool value) {
    print("handle optimism");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ListViews"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
	itemBuilder: (BuildContext context,int index) { return new Card( child: new Text(data[index]["name"]) ); })
    );
  }

}
