import 'package:obsmobile/imports.dart';

class ProfileTabData extends ChangeNotifier{
  
  // holds the flag to control the password visibility
  bool _showPassword = false;

  // getter and setter for _showPassword
  bool getShowPassword() => _showPassword;
  void setShowPassword() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

}