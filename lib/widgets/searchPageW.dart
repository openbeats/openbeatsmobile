import 'package:flutter/material.dart';

import '../globals/globalColors.dart' as globalColors;
import '../globals/globalVars.dart' as globalVars;
import '../globals/actions/globalVarsA.dart' as globalVarsA;

// holds the AppBar for the SearchPage
Widget appBar(TextEditingController queryFieldController,
    getImmediateSearchSuggestions, BuildContext context) {
  return AppBar(
    elevation: 0,
    titleSpacing: 0.0,
    backgroundColor: globalColors.textFieldBgClr,
    title: Container(
      child: TextField(
        autofocus: true,
        autocorrect: true,
        enableSuggestions: true,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search for songs, artists, audio books...",
          suffixIcon: (queryFieldController.text.length != 0)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // clearing global instance of search string
                    globalVarsA.updatecurrSearchedString("");
                    // clearing value stored in the controller
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => queryFieldController.clear());
                  },
                )
              : null,
        ),
        onChanged: (String value) {
          // updating the current string to the global instace
          globalVarsA.updatecurrSearchedString(value);
          // check if the current string is not empty
          if (value.length != 0)
            // get search suggestions for the search string
            getImmediateSearchSuggestions(value);
        },
        onSubmitted: (String value) {},
      ),
    ),
  );
}
