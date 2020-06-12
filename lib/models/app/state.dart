import '../../imports.dart';

class ApplicationState extends ChangeNotifier {
  int _bottomNavCurrentIndex = 0;
  // used to get the current index of bottomNavBar
  int getBottomNavBarCurrentIndex() => _bottomNavCurrentIndex;
  // used to set the current index of bottomNavBar
  void setBottomNavBarCurrentIndex(int indexValue) {
    _bottomNavCurrentIndex = indexValue;
    notifyListeners();
  }
}
