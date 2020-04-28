import 'package:flutter/material.dart';

import '../../../widgets/tabW/searchTab/searchHomeViewW.dart'
    as searchHomeViewW;

class SearchHomeView extends StatefulWidget {
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchHomeViewW.appBar(),
      body: searchHomeViewBody(),
    );
  }

  // holds the searchHomeView Body implementation
  Widget searchHomeViewBody() {
    return Container(
      child: ListView(
        children: <Widget>[
          searchHomeViewW.searchHomeViewSearchInstruction(context)
        ],
      ),
    );
  }
}
