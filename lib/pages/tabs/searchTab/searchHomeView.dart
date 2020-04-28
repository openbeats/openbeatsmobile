import 'package:flutter/material.dart';

import '../../../widgets/tabW/searchTab/searchHomeViewW.dart'
    as searchHomeViewW;

class SearchHomeView extends StatefulWidget {
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  // navigate to searchNowView
  void navigateToSearchNowView() {
    Navigator.of(context).pushNamed('/searchNow');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchHomeViewW.appBar(navigateToSearchNowView),
      body: searchHomeViewBody(),
    );
  }

  // holds the searchHomeView Body implementation
  Widget searchHomeViewBody() {
    return Container(
      child: searchHomeViewW.searchHomeViewSearchInstruction(context),
    );
  }
}
