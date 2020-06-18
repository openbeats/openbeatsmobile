import 'package:obsmobile/imports.dart';

// get all the data stored in sharedpreferences and update it in provider
void getAllSharedPrefsData(context) async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // getting search history list
  Provider.of<SearchTabModel>(context, listen: false)
      .updateSearchHistory(prefs.getStringList("searchHistory"));
}

// update the sharedpreferences list of search history
void updateSearchHistorySharedPrefs(List<String> _searchHistory) async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // updating the sharedPreferences copy of search history
  prefs.setStringList("searchHistory", _searchHistory);
}
