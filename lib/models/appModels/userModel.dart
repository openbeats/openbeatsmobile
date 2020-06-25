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

  // holds the users collection data as JSON
  var _userCollections = {};

  // getter and setter for user details
  Map<String, String> getUserDetails() => _userDetails;
  void setUserDetails(Map<String, String> value) {
    _userDetails = value;
    notifyListeners();
  }

  // getter and setter for user collections
  dynamic getUserCollections() => _userCollections;
  void setUserCollections(var value) {
    _userCollections = value;
    notifyListeners();
  }
}
