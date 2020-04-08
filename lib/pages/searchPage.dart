import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/searchPageW.dart' as searchPageW;
import '../globals/globalColors.dart' as globalColors;
import '../globals/globalFun.dart' as globalFun;
import '../globals/globalStrings.dart' as globalStrings;
import '../globals/actions/globalStringsA.dart' as globalStringsA;
import 'dart:math' as math;

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
            "Not able to connect to internet",
            globalColors.snackBarErrorMsgColor,
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
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    queryFieldController.dispose();
    super.dispose();
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
      child: (suggestionResponseList.length != 0)
          ? suggestionsListBuilder(false)
          : (globalStrings.searchHistory.length != 0)
              ? suggestionsListBuilder(true)
              : Container(),
    );
  }

  // holds the list view builder responsible for showing the suggestions
  Widget suggestionsListBuilder(showHistory) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        suggestionsTitleW(showHistory),
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              suggestionsListTile(context, index, showHistory),
          itemCount: (showHistory)
              ? (globalStrings.searchHistory.length < 10)
                  ? globalStrings.searchHistory.length
                  : 10
              : suggestionResponseList.length,
        )
      ],
    );
  }

  // holds the title for the suggestions and searchHistory list
  Widget suggestionsTitleW(bool showHistory) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
      child: Text(
        (showHistory) ? "Search History" : "Suggestions",
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // holds the listTiles containing the suggestions and searchHistory
  Widget suggestionsListTile(
      BuildContext context, int index, bool showHistory) {
    return ListTile(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Text(
          (showHistory)
              ? globalStrings.searchHistory[index]
              : suggestionResponseList[index][0],
          style: TextStyle(
            color: globalColors.searchPageSuggestionsColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: Icon(
        Icons.search,
        color: globalColors.searchPageSuggestionsIconColor,
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            updateQueryBtn(showHistory, index),
            SizedBox(
              width: 2.0,
            ),
            deleteSearchResultBtn(showHistory, index),
          ],
        ),
      ),
      onTap: () {
        // setting global variable to persist search
        globalStringsA.updateSearchPageCurrSearchQuery((showHistory)
            ? globalStrings.searchHistory[index]
            : suggestionResponseList[index][0]);
        // going back to previous screen with the suggestion data
        Navigator.pop(
            context,
            (showHistory)
                ? globalStrings.searchHistory[index]
                : suggestionResponseList[index][0]);
      },
    );
  }

  Widget updateQueryBtn(bool showHistory, int index) {
    return Transform.rotate(
        angle: -50 * math.pi / 180,
        child: IconButton(
          tooltip: "Update query",
          icon: Icon(Icons.arrow_upward),
          iconSize: 20.0,
          onPressed: () {
            // setting global variable to persist search
            globalStringsA.updateSearchPageCurrSearchQuery((showHistory)
                ? globalStrings.searchHistory[index]
                : suggestionResponseList[index][0]);

            // sending the current text to the search field
            sendSuggestionToField((showHistory)
                ? globalStrings.searchHistory[index]
                : suggestionResponseList[index][0]);
          },
          color: globalColors.searchPageSuggestionsIconColor,
        ));
  }

  Widget deleteSearchResultBtn(bool showHistory, int index) {
    return Container(
      child: (showHistory)
          ? IconButton(
              tooltip: "Delete Search Result",
              icon: Icon(Icons.clear),
              iconSize: 20.0,
              onPressed: () {
                setState(() {
                  // removing search histoy listing
                  globalStrings.searchHistory.removeAt(index);
                });
                globalFun.updateSearchHistorySharedPrefs();
              },
              color: globalColors.searchPageSuggestionsIconColor,
            )
          : null,
    );
  }
}
