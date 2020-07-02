import 'package:obsmobile/imports.dart';

class UserModel extends ChangeNotifier {
  // holds the user details
  Map<String, String> _userDetails = {
    "token": null,
    "name": null,
    "email": null,
    "id": null,
    "avatar": null
  };

  // holds the recently played list
  List<dynamic> _recentlyPlayedList;

  // getter and setter for the _recentlyPlayedList
  List<dynamic> getRecentlyPlayedList() => _recentlyPlayedList;
  void setRecentlyPlayedList(List<dynamic> value) {
    _recentlyPlayedList = value;
  }

  // getter and setter for user details
  Map<String, String> getUserDetails() => _userDetails;
  void setUserDetails(Map<String, String> value) {
    _userDetails = value;
    notifyListeners();
  }
}
