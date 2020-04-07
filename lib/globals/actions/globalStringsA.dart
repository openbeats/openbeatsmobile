import 'package:flutter/material.dart';
import '../globalStrings.dart' as globalStrings;

// searchPage.dart
// updates the value of the searchPageCurrSearchQuery
void updateSearchPageCurrSearchQuery(String value) {
  globalStrings.searchPageCurrSearchQuery = value;
}

// inserts query into searchHistory
void insertSearchHistoryValue(int position, String value) {
  globalStrings.searchHistory.insert(position, value);
}

// removes query from searchHistory
void removeSearchHistoryValue(String value) {
  globalStrings.searchHistory.remove(value);
}

// sets the seachHistory from another list
void setSearchHistoryFromList(List<String> historyPrefs) {
  globalStrings.searchHistory = historyPrefs;
}
