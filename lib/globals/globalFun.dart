import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/actions/globalVarsA.dart' as globalVarsA;
import '../globals/globalVars.dart' as globalVars;

// function to show snackBars
void showSnackBars(GlobalKey<ScaffoldState> scaffoldKey, context,
    snackBarContent, snackBarBGColors, snackBarDuration) {
  // forming required snackbar
  SnackBar statusSnackBar = SnackBar(
    content: Text(snackBarContent),
    backgroundColor: snackBarBGColors,
    duration: snackBarDuration,
  );
  // removing any previous snackBar
  scaffoldKey.currentState.removeCurrentSnackBar();
  // showing new snackBar
  scaffoldKey.currentState.showSnackBar(statusSnackBar);
}

// gets the search history from sharedPreferences
void getSearchHistory() async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> searchHistoryPrefs = prefs.getStringList("searchStrings");
  if (searchHistoryPrefs != null) {
    globalVarsA.setSearchHistoryFromList(searchHistoryPrefs);
  }
}

// adds value to search history
void addToSearchHistory(String query) async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ((globalVars.searchHistory.length == 0) ||
      (globalVars.searchHistory[0] != query)) {
    // removing the instance of the same query in the searchHistory list if it is at the top
    globalVarsA.removeSearchHistoryValue(query);
    globalVarsA.insertSearchHistoryValue(0, query);
    prefs.setStringList("searchStrings", globalVars.searchHistory);
  }
}

// updates the search history sharedPrefs value
void updateSearchHistorySharedPrefs() async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("searchStrings", globalVars.searchHistory);
}
