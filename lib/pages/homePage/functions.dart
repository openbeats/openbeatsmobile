import 'package:obsmobile/imports.dart';

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

// used to change the status bar color
void changeStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      /* set Status bar color in Android devices. */
      statusBarColor: GlobalThemes().getAppTheme().scaffoldBackgroundColor,
      /* set Status bar icons color in Android devices.*/
      statusBarIconBrightness: Brightness.light,
      /* set Status bar icon color in iOS. */
      statusBarBrightness: Brightness.dark,
    ),
  );
}

// general function used to check if the slideUpPanel should be visible or not
void shouldShowSlideUpPanel() {
  if (getSlidingUpPanelController().isAttached) {
    // checking once if the AudioService panel should be shown
    if (AudioService.running) {
      getSlidingUpPanelController().show();
    } else {
      getSlidingUpPanelController().hide();
    }
  }
}
