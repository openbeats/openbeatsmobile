import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './globalStrings.dart' as globalStrings;
import './actions/globalStringsA.dart' as globalStringsA;

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
    globalStringsA.setSearchHistoryFromList(searchHistoryPrefs);
  }
}

// adds value to search history
void addToSearchHistory(String query) async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ((globalStrings.searchHistory.length == 0) ||
      (globalStrings.searchHistory[0] != query)) {
    // removing the instance of the same query in the searchHistory list if it is at the top
    globalStringsA.removeSearchHistoryValue(query);
    globalStringsA.insertSearchHistoryValue(0, query);
    prefs.setStringList("searchStrings", globalStrings.searchHistory);
  }
}

// updates the search history sharedPrefs value
void updateSearchHistorySharedPrefs() async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("searchStrings", globalStrings.searchHistory);
}

// function to show ToastMessage
void showToastMessage(
    String message, Color bgColor, Color txtColor, bool toastLengthLong) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: (toastLengthLong) ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: bgColor,
    textColor: txtColor,
    fontSize: 16.0,
  );
}
