import 'package:openbeatsmobile/imports.dart';

// called when the slideUp Panel slides to hide the bottomNavBar
void manageBottomNavVisibility(
    double slidePosition, AnimationController _hideBottomNavBarAnimController) {
  if (slidePosition > 0.7)
    _hideBottomNavBarAnimController.reverse();
  else if (slidePosition < 0.2) _hideBottomNavBarAnimController.forward();
}

// handles the onWillPop callback
Future<bool> onWillPopCallbackHandler(BuildContext context,
    PanelController _panelController, int navBarCurrentIndex) async {
  // checking if the SlidingUpPanel is open
  if (_panelController.isPanelOpen) {
    _panelController.close();
    return false;
  }
  // if SlideUpPanel is closed
  else {
    // checking which tab is in view
    switch (navBarCurrentIndex) {
      // if searchTab is in view
      case 1:
        // checking if searchNowView is still in use
        if (homePageScaffoldKey.currentContext != null) {
          Navigator.of(searchNowPageScaffoldKey.currentContext).pop();
          return false;
        } else {
          return true;
        }
        break;
      default:
        return true;
    }
  }
}
