import 'package:openbeatsmobile/imports.dart';

class StartUpSharedPrefs {
  // loads data from the shared preferences
  void loadSharedPrefsData() async {
    // getting shared preference instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // loading search history data
    updateSearchHistory(prefs.getStringList("searchStrings"));
  }
}
