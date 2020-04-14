import 'package:flutter/material.dart';
import '../globals/globalColors.dart' as globalColors;
import '../globals/actions/globalStringsA.dart' as globalStringsA;

// holds the appBar for the SearchPage
Widget appBar(TextEditingController queryFieldController,
    getImmediateSuggestions, BuildContext context) {
  return AppBar(
    elevation: 0,
    titleSpacing: 0.0,
    title: Container(
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: globalColors.sPTextFieldBGColor,
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
        onChanged: (String value) {
          // updating the global variable for search text persistance
          globalStringsA.updateSearchPageCurrSearchQuery(value);
          // getting length of input
          int valueLen = value.length;
          // checking if the input is not empty and if it is
          // meeting parameters to help reduce network calls
          if (valueLen > 0)
            // calling function to immediately get suggestions
            getImmediateSuggestions(value);
        },
        onSubmitted: (String value) {
          // going back to previous screen with the suggestion data
          Navigator.pop(context, value);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search for songs, artists, audio books...",
          suffixIcon: (queryFieldController.text.length == 0)
              ? null
              : IconButton(
                  onPressed: () {
                    globalStringsA.updateSearchPageCurrSearchQuery("");
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => queryFieldController.clear());
                  },
                  icon: Icon(Icons.clear),
                ),
          hintStyle: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ),
    actions: <Widget>[searchButton(queryFieldController, context)],
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
        globalStringsA
            .updateSearchPageCurrSearchQuery(queryFieldController.text);
        // going back to previous screen with the suggestion data
        Navigator.pop(context, queryFieldController.text);
      },
    ),
  );
}
