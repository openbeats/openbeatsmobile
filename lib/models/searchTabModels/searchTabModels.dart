import 'package:obsmobile/imports.dart';

class SearchTabModel extends ChangeNotifier {
  // holds the list of suggestions for SearchNowPage
  List _searchSuggestions = new List();
  // holds the list of search results
  List _searchResults = new List();
  // holds the delay flag to stop updating the search suggestions till there are new values in the textfield
  bool _delayFlag = false;
  // holds the current searched string
  String _currentSearchString = "";

  // used to get the search suggestions
  List getSearchSuggestions() => _searchSuggestions;
  // used to get the search results
  List getSearchResults() => _searchResults;
  // used to get the current search string
  String getCurrentSearchString() => _currentSearchString;

  // used to update the search suggestions
  void updateSearchSuggestions(List value) {
    if (!_delayFlag) {
      _searchSuggestions = value;
      notifyListeners();
    }
  }

  // used to update the search results
  void updateSearchResults(List value) {
    _searchResults = value;
    notifyListeners();
  }

  // used to set the delay flag
  void setDelayFlag(bool value) => _delayFlag = value;

  // used to update the current search string
  void setCurrentSearchString(String value) {
    _currentSearchString = value;
  }
}
