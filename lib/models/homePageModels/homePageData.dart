import 'package:obsmobile/imports.dart';

class HomePageData extends ChangeNotifier {
  // holds the current index of the bottomNavBar
  int _bNavBarCurrIndex = 0;

  // getter and setter for _bNvBarCurrIndex
  int getBNavBarCurrIndex() => _bNavBarCurrIndex;
  void setBNavBarCurrIndex(int value) {
    _bNavBarCurrIndex = value;
    notifyListeners();
  }
}
