import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/searchPageW.dart' as searchPageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalFun.dart' as globalFun;
import '../globals/globalStrings.dart' as globalStrings;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // holds the list of suggestions
  List suggestionResponseList = new List();
  // scaffold key for snackBar
  final GlobalKey<ScaffoldState> searcPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  // controller to monitor if the textField becomes empty
  final TextEditingController queryFieldController =
      new TextEditingController();
  // flag variable to solve the problem of delayed api calls
  // true - add suggestions to list
  // false - do not let suggestions to list
  bool delayCallFlag = true;
  // holds data if the no internet snackbar is shown
  bool noInternetSnackbarShown = false;

  // gets suggestions as the user is typing
  void getImmediateSuggestions(String query) async {
    // simply updating state
    setState(() {});
    // construct dynamic url based on current query
    String url = "https://api.openbeats.live/suggester?k=" + query;
    // setting up exception handlers to alert for network issues
    try {
      // sending request through http as JSON
      var responseJSON = await Dio().get(url);
      // if delay flag is false, let value enter
      if (!delayCallFlag) {
        setState(() {
          // getting the list of responses
          suggestionResponseList = responseJSON.data["data"] as List;
          noInternetSnackbarShown = false;
        });
      }
      // removing the noInternet snackbar when internet connection is returned
      searcPageScaffoldKey.currentState.removeCurrentSnackBar();
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        if (!noInternetSnackbarShown) {
          globalFun.showSnackBars(
            searcPageScaffoldKey,
            context,
            "Internet Connection unavailable",
            Colors.red,
            Duration(minutes: 30),
          );
          setState(() {
            noInternetSnackbarShown = true;
          });
        }
      }
    }
  }

  // calling function to monitor the textField to handle delayed responses
  // and empty textField edge cases
  void addListenerToSearchTextField() {
    // adding listener to textField
    queryFieldController.addListener(() {
      if (queryFieldController.text.length == 0) {
        setState(() {
          // setting delay flag to block till the field has value again
          delayCallFlag = true;
          // clearing the suggestion response list
          suggestionResponseList.clear();
        });
      } else {
        setState(() {
          // setting delay flag to let value enter
          delayCallFlag = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // calling function to monitor the textField to handle delayed responses
    // and empty textField edge cases
    addListenerToSearchTextField();
    // to check if the global value Exists to be inserted
    if (globalStrings.searchPageCurrSearchQuery.length > 1) {
      // inserting persistent text into the field
      queryFieldController.text = globalStrings.searchPageCurrSearchQuery;
      // setting cursor to end of the inserted text
      queryFieldController.selection = TextSelection.fromPosition(
          TextPosition(offset: queryFieldController.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: searcPageScaffoldKey,
      backgroundColor: globalColors.appBackgroundColor,
      appBar: searchPageW.appBar(
          queryFieldController, getImmediateSuggestions, context),
      body: searchPageBody(),
    );
  }

  // holds the body implementation of searchPage
  Widget searchPageBody() {
    return Container(
      child: null,
    );
  }
}
