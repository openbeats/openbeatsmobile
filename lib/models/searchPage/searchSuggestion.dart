import '../../imports.dart';

class SearchSuggestionsProvider extends ChangeNotifier {
  // holds the current searched string
  String _currSearchString = "";
  // holds the list of strings as search history
  List<String> _searchHistory = new List();

  // used to get the current searched string
  String getCurrSearchString() => _currSearchString;
  // used to set the current searched string
  void setCurrSearchString(String value) {
    _currSearchString = value;
    notifyListeners();
  }

  // used to get the search history list
  List<String> getSearchHistory() => _searchHistory;
  // used to set/update the search history
  void updateSearchHistory(List<String> values) {
    _searchHistory = values;
    notifyListeners();
  }
  
}
