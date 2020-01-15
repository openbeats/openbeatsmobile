import 'package:flutter/material.dart';

import '../globalVars.dart' as globalVars;

// holds the appBar for the homePage
Widget appBarW(context) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: globalVars.primaryDark,
    title: Image.asset(
      "assets/images/logo/logotext.png",
      height: 40.0,
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Navigator.pushNamed(context, '/searchPage');
        },
        color: globalVars.primaryLight,
      ),
    ],
  );
}

Widget homePageView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[hiText(), welcomeText()],
  );
}

Widget hiText() {
  return Text("Hi!", style: TextStyle(fontSize: 70.0, color: Colors.grey));
}

Widget welcomeText() {
  return Text(
    "Try searching for any \nsong, podcast or audiobook you like",
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey, fontSize: 20.0),
  );
}
