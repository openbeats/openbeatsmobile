import 'package:flutter/material.dart';

// holds the AppBar for the searchHomeView
Widget appBar() {
  return AppBar(
    title: Text("Search"),
    actions: <Widget>[searchButtonAppBar()],
  );
}

// holds the search button for the AppBar
Widget searchButtonAppBar() {
  return IconButton(
    icon: Icon(Icons.search),
    onPressed: () {},
  );
}
