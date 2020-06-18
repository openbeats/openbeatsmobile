import 'package:obsmobile/imports.dart';

// update the sharedpreferences list of search history
void updateSearchHistorySharedPrefs(List<String> _searchHistory) async{
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // updating the sharedPreferences copy of search history
  prefs.setStringList("searchHistory", _searchHistory);
}