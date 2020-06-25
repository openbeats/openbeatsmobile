import 'package:obsmobile/imports.dart';

// get all the data stored in sharedpreferences and update it in provider
void getAllSharedPrefsData(context) async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // getting search history list
  List<String> _searchHistoryList = prefs.getStringList("searchHistory");
  if (_searchHistoryList != null)
    Provider.of<SearchTabModel>(context, listen: false)
        .updateSearchHistory(prefs.getStringList("searchHistory"));

  // getting the user details preferences
  Map<String, String> _userDetails = {
    "token": prefs.getString("token"),
    "name": prefs.getString("name"),
    "email": prefs.getString("email"),
    "id": prefs.getString("id"),
    "avatar": prefs.getString("avatar")
  };
  // sending data to store in application model
  Provider.of<UserModel>(context, listen: false).setUserDetails(_userDetails);
}

// update the sharedpreferences list of search history
void updateSearchHistorySharedPrefs(List<String> _searchHistory) async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // updating the sharedPreferences copy of search history
  prefs.setStringList("searchHistory", _searchHistory);
}

// insert user details in sharedPrefs on login
void storeUserDetails(Map<String, String> _data) async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", _data["token"]);
  prefs.setString("name", _data["name"]);
  prefs.setString("email", _data["email"]);
  prefs.setString("id", _data["id"]);
  prefs.setString("avatar", _data["avatar"]);
}

// removes the user details from the sharedPrefs on logout
void removeUserDetails() async {
  // getting sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("token", null);
  prefs.setString("name", null);
  prefs.setString("email", null);
  prefs.setString("id", null);
  prefs.setString("avatar", null);
}
