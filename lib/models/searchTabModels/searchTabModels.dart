import 'package:obsmobile/imports.dart';

class SearchTabModel extends ChangeNotifier {
  // holds the current searched string
  String _currentSearchString = "";
  // holds the list of suggestions for SearchNowPage
  List _searchSuggestions = new List();

  // used to get the current search string
  String getCurrentSearchString() => _currentSearchString;
  // used to get teh search suggestions
  List getSearchSuggestions() => _searchSuggestions;
  // used to update the current search string
  void setCurrentSearchString(String value) {
    _currentSearchString = value;
    notifyListeners();
  }

  // used to update the search suggestions
  void updateSearchSuggestions(List value) {
    _searchSuggestions = value;
    notifyListeners();
  }
}
