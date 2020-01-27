import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../globalVars.dart' as globalVars;

// holds the searchPage appbar
Widget appBarSearchPageW(queryFieldController,
    getImmediateSuggestions, BuildContext context) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: globalVars.primaryDark,
    title: TextField(
      style: TextStyle(color: Colors.white),
      controller: queryFieldController,
      onChanged: (String value) {
        // updating the global variable for search text persistance
        globalVars.currSearchText = value;
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
      textInputAction: TextInputAction.search,
      autofocus: true,
      decoration: InputDecoration(
        suffixIcon: (queryFieldController.text.length == 0)?null:IconButton(
          onPressed: (){
            globalVars.currSearchText = "";
            WidgetsBinding.instance.addPostFrameCallback( (_) => queryFieldController.clear());
            
          },
          icon: Icon(Icons.clear),
          color: globalVars.accentWhite,
        ),
        border: InputBorder.none,
        hintText: "Search for songs, artists, audio books...",
        hintStyle: TextStyle(color: Colors.white70),
      ),
    ),
  );
}

