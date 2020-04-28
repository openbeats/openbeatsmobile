import 'package:flutter/material.dart';

import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/actions/globalVarsA.dart' as globalVarsA;

// holds the AppBar for the searchNowView
Widget appBar(TextEditingController queryFieldController,
    Function getSearchSuggestions, BuildContext context) {
  return AppBar(
    titleSpacing: 0.0,
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
      borderRadius: BorderRadius.circular(8.0),
      color: globalColors.textFieldBgClr,
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
