import 'package:obsmobile/imports.dart';

class HomePageData extends ChangeNotifier {
  // holds the current index of the bottomNavBar
  int _bNavBarCurrIndex = 0;
  double _collapsedSlideUpPanelHeight = 70.0;

  // getter and setter for _bNvBarCurrIndex
  int getBNavBarCurrIndex() => _bNavBarCurrIndex;
  void setBNavBarCurrIndex(int value) {
    _bNavBarCurrIndex = value;
    notifyListeners();
  }

  // getter for _collapsedSlideUpPanekHeight
  double getCollapsedSlideUpPanelHeight() => _collapsedSlideUpPanelHeight;
  // used to modify the height of the slidingUpPanelCollapsed
  void modifyCollapsedPanel() {
    if (AudioService.running) {
      if (_collapsedSlideUpPanelHeight == 0.0) {
        _collapsedSlideUpPanelHeight = 70.0;
        notifyListeners();
      }
    } else {
      if (_collapsedSlideUpPanelHeight == 70.0) {
        _collapsedSlideUpPanelHeight = 0.0;
        notifyListeners();
      }
    }
  }
}
