import 'package:obsmobile/imports.dart';

class GlobalFuncs {
  // handles the navBackButton input using WillPopScope
  Future<bool> willPopScopeHandler() async {
    // checking if the SlidingUpPanel is open
    if (getSlidingUpPanelController().isPanelOpen) {
      getSlidingUpPanelController().close();
      return false;
    } else if (searchNowPageScaffoldKey.currentContext != null) {
      Navigator.of(searchNowPageScaffoldKey.currentContext).pop();
      return false;
    }
    return true;
  }
}
