import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/searchPageW.dart' as searchPageW;
import '../globalVars.dart' as globalVars;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // holds the list of suggestions
  List suggestionResponseList = new List();
  // scaffold key for snackBar
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  // flag variable to solve the problem of delayed api calls
  // true - add suggestions to list
  // false - do not let suggestions to list
  bool delayCallFlag = true;

  // controller to monitor if the textField becomes empty
  final TextEditingController queryFieldController =
      new TextEditingController();

  // gets suggestions as the user is typing
  void getImmediateSuggestions(String query) async {
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
        });
      }
    } catch (e) {
      // catching dio error
      if (e is DioError) {
        // removing previous snackBar
        scaffoldKey.currentState.removeCurrentSnackBar();
        // showing snackBar to alert user about network status
        scaffoldKey.currentState.showSnackBar(globalVars.networkErrorSBar);
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

  // sends suggestions to the textField
  void sendSuggestionToField(String suggestion) {
    // modifying query field value
    queryFieldController.text = suggestion;
    // sending cursor to end of queryField
    queryFieldController.selection =
        TextSelection.collapsed(offset: queryFieldController.text.length);
    // calling function to update suggestions
    getImmediateSuggestions(suggestion);
  }

  @override
  void initState() {
    super.initState();
    // calling function to monitor the textField to handle delayed responses
    // and empty textField edge cases
    addListenerToSearchTextField();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    queryFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF09090E),
        appBar: searchPageW.appBarSearchPageW(
            queryFieldController, getImmediateSuggestions, context),
        body: (suggestionResponseList.length != 0)
            ? searchResultListView()
            : Container(),
      ),
    );
  }

  // holds the list view builder responsible for showing the suggestions
  Widget searchResultListView() {
    return ListView.builder(
      itemBuilder: suggestionsListBuilder,
      itemCount: suggestionResponseList.length,
    );
  }

  // builds the suggestions listView
  Widget suggestionsListBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(
        suggestionResponseList[index][0],
        style: TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        tooltip: "Update query",
        icon: Icon(FontAwesomeIcons.angleUp),
        onPressed: () {
          // sending the current text to the search field
          sendSuggestionToField(suggestionResponseList[index][0]);
        },
        color: Colors.blueGrey,
      ),
      onTap: () {
        // going back to previous screen with the suggestion data
        Navigator.pop(context, suggestionResponseList[index][0]);
      },
    );
  }
}
