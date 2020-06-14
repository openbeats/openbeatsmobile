import '../../imports.dart';

class ApplicationState extends ChangeNotifier {
  // holds the api host address for the entire application
  String _apiHostAddress = "https://api-staging.openbeats.live";
  int _bottomNavCurrentIndex = 0;

  // used to get the current api host address
  String getApiHostAddress() => _apiHostAddress;

  // used to get the current index of bottomNavBar
  int getBottomNavBarCurrentIndex() => _bottomNavCurrentIndex;
  // used to set the current index of bottomNavBar
  void setBottomNavBarCurrentIndex(int indexValue) {
    _bottomNavCurrentIndex = indexValue;
    notifyListeners();
  }
}
