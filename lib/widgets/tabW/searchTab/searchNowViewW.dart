import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/globalVars.dart' as globalVars;
import '../../../globals/actions/globalVarsA.dart' as globalVarsA;

// holds the AppBar for the searchNowView
Widget appBar(TextEditingController queryFieldController,
    Function getSearchSuggestions, BuildContext context) {
  return AppBar(
    titleSpacing: 0.0,
    elevation: 0,
    title: _appBarTitle(queryFieldController, getSearchSuggestions, context),
    actions: <Widget>[searchButton(queryFieldController, context)],
  );
}

// holds the AppBar title
Widget _appBarTitle(TextEditingController queryFieldController,
    Function getSearchSuggestions, BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: TextField(
      controller: queryFieldController,
      textInputAction: TextInputAction.search,
      autofocus: true,
      autocorrect: true,
      enableSuggestions: true,
      style: TextStyle(
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search for songs, artists, audio books...",
        suffixIcon: (queryFieldController.text.length == 0)
            ? null
            : IconButton(
                onPressed: () {
                  // updating the global variable for search text persistance
                  globalVarsA.updatecurrSearchedString("");
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => queryFieldController.clear());
                },
                icon: Icon(Icons.clear),
              ),
        hintStyle: TextStyle(
          fontSize: 16.0,
        ),
      ),
      onChanged: (String value) {
        // updating the global variable for search text persistance
        globalVarsA.updatecurrSearchedString(value);
        // getting length of input
        int valueLen = value.length;
        // checking if the input is not empty and if it is
        // meeting parameters to help reduce network calls
        if (valueLen > 0)
          // calling function to immediately get suggestions
          getSearchSuggestions(value);
      },
      onSubmitted: (String value) {
        // going back to previous screen with the suggestion data
        Navigator.pop(context, value);
      },
    ),
  );
}

// holds the search button
Widget searchButton(
    TextEditingController queryFieldController, BuildContext context) {
  return Container(
    child: IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // setting global variable to persist search
        globalVarsA.updatecurrSearchedString(queryFieldController.text);
        // going back to previous screen with the suggestion data
        Navigator.pop(context, queryFieldController.text);
      },
    ),
  );
}

// holds the title for the suggestions and searchHistory list titles
Widget suggestionsTitleW(bool showHistory) {
  return Container(
    margin: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 5.0),
    child: Text(
      (showHistory) ? "Search History" : "Suggestions",
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// holds the listTiles containing the suggestions and searchHistory
Widget suggestionsListTile(BuildContext context, int index, bool showHistory,
    List suggestionResponseList, Function sendSuggestionToField) {
  return ListTile(
    title: Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        (showHistory)
            ? globalVars.searchHistory[index]
            : suggestionResponseList[index][0],
        style: TextStyle(
          color: globalColors.textDisabledClr,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    leading: Icon(
      Icons.search,
      color: globalColors.iconDisabledClr,
    ),
    trailing: updateQueryBtn(context, showHistory, index, sendSuggestionToField,
        suggestionResponseList),
    onTap: () {
      // setting global variable to persist search
      globalVarsA.updatecurrSearchedString((showHistory)
          ? globalVars.searchHistory[index]
          : suggestionResponseList[index][0]);
      // going back to previous screen with the suggestion data
      Navigator.pop(
          context,
          (showHistory)
              ? globalVars.searchHistory[index]
              : suggestionResponseList[index][0]);
    },
  );
}

Widget updateQueryBtn(BuildContext context, bool showHistory, int index,
    Function sendSuggestionToField, List suggestionResponseList) {
  return GestureDetector(
    child: Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width * 0.07,
      child: Transform.rotate(
        angle: -50 * math.pi / 180,
        child: Icon(
          Icons.arrow_upward,
          size: 22.0,
          color: globalColors.iconDisabledClr,
        ),
      ),
    ),
    onTap: () {
      // setting global variable to persist search
      globalVarsA.updatecurrSearchedString((showHistory)
          ? globalVars.searchHistory[index]
          : suggestionResponseList[index][0]);

      // sending the current text to the search field
      sendSuggestionToField((showHistory)
          ? globalVars.searchHistory[index]
          : suggestionResponseList[index][0]);
    },
  );
}
