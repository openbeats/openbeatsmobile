import 'package:flutter/material.dart';

class SearchNowView extends StatefulWidget {
  @override
  _SearchNowViewState createState() => _SearchNowViewState();
}

class _SearchNowViewState extends State<SearchNowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searchNowViewBody(),
    );
  }

  // holds the SearchNowView Body
  Widget searchNowViewBody() {
    return Center(
      child: Text("SearchNow View"),
    );
  }
}
