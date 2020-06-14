import 'package:openbeatsmobile/imports.dart';

// adds value to search history
void addToSearchHistorySharedPrefs(BuildContext context, String query) async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> searchHistory = getSearchHistory();
  if ((searchHistory.length == 0) || (searchHistory[0] != query)) {
    // removing the instance of the same query in the searchHistory list if it is at the top
    searchHistory.remove(query);
    searchHistory.insert(0, query);
    // updating search string reference in provider
    updateSearchHistory(searchHistory);
    // updating search history value in shared preference
    prefs.setStringList("searchStrings", searchHistory);
  }
}
