import 'package:obsmobile/imports.dart';

class ProfileTabData extends ChangeNotifier {
  // holds the flag to control the password visibility
  bool _showPasswordJoin = false;
  bool _showPasswordSignIn = false;
  // holds the loading flag
  bool _isLoading = false;

  // getter and setter for _showPasswordJoin
  bool getShowPasswordJoin() => _showPasswordJoin;
  void setShowPasswordJoin() {
    _showPasswordJoin = !_showPasswordJoin;
    notifyListeners();
  }

  // getter and setter for _showPasswordSignIn
  bool getShowPasswordSignIn() => _showPasswordSignIn;
  void setShowPasswordSignIn() {
    _showPasswordSignIn = !_showPasswordSignIn;
    notifyListeners();
  }

  // getter and setter for _isLoading
  bool getIsLoading() => _isLoading;
  void setIsLoading(bool value) {
    _isLoading = value;
  }
}
