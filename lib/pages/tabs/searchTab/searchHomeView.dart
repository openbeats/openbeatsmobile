import 'package:flutter/material.dart';

import '../../../widgets/tabW/searchTab/searchHomeViewW.dart'
    as searchHomeViewW;
import '../../../globals/globalFun.dart' as globalFun;

class SearchHomeView extends StatefulWidget {
  @override
  _SearchHomeViewState createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  // flag used to indicate that the search results are loading
  bool searchResultLoading = false;

  // navigate to searchNowView
  void navigateToSearchNowView() async {
    // getting the latest search result history into the global variable
    globalFun.getSearchHistory();
    // navigating to searchNowView.dart and waiting for search query
    var selectedSearchString =
        await Navigator.of(context).pushNamed('/searchNow');

    // checking if the user has returned something
    if (selectedSearchString != null &&
        selectedSearchString.toString().length > 0) {
      // set the page to loading animation
      setState(() {
        searchResultLoading = true;
      });
      // adding the query to the search results history
      globalFun.addToSearchHistory(selectedSearchString);
      // calling function to get videos for query
      // getVideosForQuery(selectedSearchString);
    }
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
