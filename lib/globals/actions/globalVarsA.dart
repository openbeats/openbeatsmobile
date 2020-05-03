import 'package:flutter/material.dart';
import '../globalVars.dart' as globalVars;

// used to update the current searched string in currSearchedString
void updatecurrSearchedString(String value) {
  globalVars.currSearchedString = value;
}

// inserts query into searchHistory
void insertSearchHistoryValue(int position, String value) {
  globalVars.searchHistory.insert(position, value);
}

// removes query from searchHistory
void removeSearchHistoryValue(String value) {
  globalVars.searchHistory.remove(value);
}

// sets the seachHistory from another list
void setSearchHistoryFromList(List<String> historyPrefs) {
  globalVars.searchHistory = historyPrefs;
}

// updates the userDetails
void updateUserDetails(Map<String, String> userDetails) {
  globalVars.userDetails = {
    "token": userDetails["token"],
    "name": userDetails["name"],
    "email": userDetails["email"],
    "id": userDetails["id"],
    "avatar": userDetails["avatar"]
  };
}
