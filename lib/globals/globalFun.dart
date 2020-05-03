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

// reformats the views count to plays in the B,M,K format
String reformatViews(String views) {
  // string to return the final count
  String plays = "";
  // removing the trailing text, and commas
  views = views.replaceFirst(" views", "").replaceAll(",", "");
  // formating number based on its string length
  if (views.length > 10) {
    plays = views[0] + views[1] + "B plays";
  } else if (views.length > 9) {
    plays = views[0] + "B plays";
  } else if (views.length > 8) {
    plays = views[0] + views[1] + views[2] + "M plays";
  } else if (views.length > 7) {
    plays = views[0] + views[1] + "M plays";
  } else if (views.length > 6) {
    plays = views[0] + "M plays";
  } else if (views.length > 5) {
    plays = views[0] + views[1] + views[2] + "K plays";
  } else if (views.length > 4) {
    plays = views[0] + views[1] + "K plays";
  } else if (views.length > 3) {
    plays = views[0] + "K plays";
  }

  return plays;
}

// reformats timestamp into seconds
int reformatTimeStampToMilliSeconds(String timeStamp) {
  // holds the seconds in integer format
  int totalSeconds = 0;
  // converting timeStamp into list of digits in integer format
  List<int> timeStampLst = timeStamp
      .split(":")
      .map((digitString) => int.parse(digitString))
      .toList();
  if (timeStampLst.length == 2) {
    // adding minutes and seconds to total seconds
    totalSeconds += (timeStampLst[0] * 60000) + (timeStampLst[1] * 1000);
  } else if (timeStampLst.length == 3) {
    // adding hours and minutes and seconds to total seconds
    totalSeconds += (timeStampLst[0] * 3600 * 1000) +
        (timeStampLst[1] * 60) +
        timeStampLst[2];
  }
  // return the total seconds
  return (totalSeconds);
}

// return the current duration string in min:sec
String getCurrentTimeStamp(double totalSeconds) {
  // variables holding separated time
  String min, sec, hour;
  // holds the total seconds to help decide if I need to send hours or not at the end
  double totalSecondsPlaceHolder = totalSeconds;
  // check if it is greater than one hour
  if (totalSeconds > 3600) {
    // getting number of hours
    hour = ((totalSeconds % (24 * 3600)) / 3600).floor().toString();
    totalSeconds %= 3600;
  }
  // getting number of minutes
  min = (totalSeconds / 60).floor().toString();
  totalSeconds %= 60;
  // getting number of seconds
  sec = (totalSeconds).floor().toString();
  // adding the necessary zeros
  if (int.parse(sec) < 10) sec = "0" + sec;
  // if the duration is greater than 1 hour, return with hour
  if (totalSecondsPlaceHolder > 3600) {
    if (double.parse(min) < 10.0) {
      return (hour.toString() + ":0" + min.toString() + ":" + sec.toString());
    } else {
      return (hour.toString() + ":" + min.toString() + ":" + sec.toString());
    }
  } else {
    if (double.parse(min) < 10.0) {
      return ("0" + min.toString() + ":" + sec.toString());
    } else {
      return (min.toString() + ":" + sec.toString());
    }
  }
}
