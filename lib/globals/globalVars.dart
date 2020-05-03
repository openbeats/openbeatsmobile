import 'package:flutter/material.dart';

// holds the API hostAddress
String apiHostAddress = "https://staging-api.openbeats.live";

// holds the sizes for widgets of app
double bottomNavBarIconSize = 28.0;

// searchPage.dart
// holds the current searched string
String currSearchedString = "";

// holds the seach history as a list of strings
List<String> searchHistory = [];

// holds persistent copy of the searchResults to help persist the data in the TabView
List persistentSearchResultsList = [];
