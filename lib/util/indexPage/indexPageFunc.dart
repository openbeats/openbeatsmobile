import '../../imports.dart';

// called when the slideUp Panel slides to hide the bottomNavBar
void manageBottomNavVisibility(
    double slidePosition, AnimationController _hideBottomNavBarAnimController) {
  if (slidePosition > 0.7)
    _hideBottomNavBarAnimController.reverse();
  else if (slidePosition < 0.2) _hideBottomNavBarAnimController.forward();
}

// handles the onWillPop callback
Future<bool> onWillPopCallbackHandler(
    BuildContext context, PanelController _panelController) async {
  print("Hi");
  // checking if the SlidingUpPanel is open
  if (_panelController.isPanelOpen) {
    _panelController.close();
    return false;
  }
  // if SlideUpPanel is closed
  else {
    print(Provider.of<ScaffoldKeys>(context).getScaffoldKey("indexPage"));
    // checking which tab is in view
    switch (Provider.of<ApplicationState>(context, listen: false)
        .getBottomNavBarCurrentIndex()) {
      // if searchTab is in view
      case 1:
        // checking if searchNowView is still in use
        if (Provider.of<ScaffoldKeys>(context, listen: false)
                .getScaffoldKey("searchPage")
                .currentContext !=
            null) {
          print("Got here");
          Navigator.of(Provider.of<ScaffoldKeys>(context, listen: false)
                  .getScaffoldKey("searchSuggestionsPage")
                  .currentContext)
              .pop();
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
