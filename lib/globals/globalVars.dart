import 'package:flutter/material.dart';

// holds the API hostAddress
String apiHostAddress = "https://staging-api.openbeats.live";

// holds the sizes for widgets of app
double bottomNavBarIconSize = 28.0;

// holds the userAuthToken if authenticated
Map<String, String> userDetails = {
  "token": null,
  "name": null,
  "email": null,
  "id": null,
  "avatar": null
};

// searchPage.dart
// holds the current searched string
String currSearchedString = "";

// holds the seach history as a list of strings
List<String> searchHistory = [];

// holds persistent copy of the searchResults to help persist the data in the TabView
List persistentSearchResultsList = [];

// holds the animation duration for all components in the app
Duration animationDuration = Duration(milliseconds: 200);
