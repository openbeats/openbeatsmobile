import 'package:obsmobile/imports.dart';

class ProfileTabData extends ChangeNotifier {
  // holds the flag to control the password visibility
  bool _showPasswordJoin = false;
  bool _showPasswordSignIn = false;
  // holds the loading flag
  bool _isLoading = false;
  // holds the autoValidate variable for signIn
  bool _signInAutoValidate = false;
  bool _joinAutoValidate = false;

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

  // getter and setter for autoValidate signIn
  bool getAutoValidateSignIn() => _signInAutoValidate;
  void setAutoValidateSignIn(bool value) {
    _signInAutoValidate = value;
    notifyListeners();
  }

  // getter and setter for autoValidate join
  bool getAutoValidateJoin() => _joinAutoValidate;
  void setAutoValidateJoin(bool value) {
    _joinAutoValidate = value;
    notifyListeners();
  }
}
