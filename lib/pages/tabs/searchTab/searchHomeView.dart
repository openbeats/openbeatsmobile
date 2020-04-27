import 'package:flutter/material.dart';

class SearchHomeView extends StatefulWidget {
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searchHomeViewBody(),
    );
  }

  // holds the searchHomeView Body implementation
  Widget searchHomeViewBody() {
    return Center(
      child: InkWell(
        child: Text("SearchHome View"),
        onTap: () {
          Navigator.pushNamed(context, "/searchNow");
        },
      ),
    );
  }
}
