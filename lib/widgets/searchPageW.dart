import 'package:flutter/material.dart';

// holds the searchPage appbar
Widget appBarSearchPageW(TextEditingController queryFieldController,
    getImmediateSuggestions, BuildContext context) {
  return AppBar(
    elevation: 0.0,
    title: TextField(
      style: TextStyle(color: Colors.white),
      controller: queryFieldController,
      onChanged: (String value) {
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
        border: InputBorder.none,
        hintText: "Search for songs, artists, audio books...",
        hintStyle: TextStyle(color: Colors.white70),
      ),
    ),
  );
}

