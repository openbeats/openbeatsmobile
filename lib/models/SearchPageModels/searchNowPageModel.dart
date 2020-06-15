// holds the current searched string
String _currSearchString = "";
// holds the list of strings as search history
List<String> _searchHistory = new List();

// used to get the current searched string
String getCurrSearchString() {
  return _currSearchString;
}

// used to set the current searched string
void setCurrSearchString(String value) {
  _currSearchString = value;
}

// used to get the search history list
List<String> getSearchHistory() {
  if (_searchHistory == null) return [];
  return _searchHistory;
}

// used to set/update the search history
void updateSearchHistory(List<String> values) {
  _searchHistory = values;
}
