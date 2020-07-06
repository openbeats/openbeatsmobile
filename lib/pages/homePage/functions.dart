import 'package:obsmobile/imports.dart';

// handles the navBackButton input using WillPopScope
Future<bool> willPopScopeHandler(BuildContext context) async {
  // checking if the SlidingUpPanel is open
  if (getSlidingUpPanelController().isPanelOpen) {
    getSlidingUpPanelController().close();
    return false;
  } else if (searchNowPageScaffoldKey.currentContext != null) {
    if (ModalRoute.of(searchNowPageScaffoldKey.currentContext).isCurrent)
      Navigator.of(searchNowPageScaffoldKey.currentContext).pop();
    return false;
  } else if (playlistViewScaffoldKey.currentContext != null) {
    if (ModalRoute.of(playlistViewScaffoldKey.currentContext).isCurrent)
      Navigator.of(playlistViewScaffoldKey.currentContext).pop();
    return false;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: GlobalThemes().getAppTheme().bottomAppBarColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      title: Text("Exit OpenBeats"),
      content: Text("Are you sure you want to exit the application?"),
      actions: <Widget>[
        FlatButton(
          textColor: GlobalThemes().getAppTheme().primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
            Future.delayed(Duration(milliseconds: 200), () {
              SystemNavigator.pop();
            });
          },
          child: Text("Exit"),
        ),
        FlatButton(
          textColor: Colors.white,
          color: Colors.green,
          onPressed: () {
            Navigator.of(context).pop();
            Future.delayed(Duration(milliseconds: 200), () {
              MoveToBackground.moveTaskToBack();
            });
            return false;
          },
          child: Text("Send to Background"),
        ),
      ],
    ),
  );
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

// used to handle page content refreshes on tab change
void handleTabChangeContentRefreshes(BuildContext context, int index) {
  // getting current user information
  String _userToken =
      Provider.of<UserModel>(context, listen: false).getUserDetails()["token"];
  // filtering tasks that require the user to be logged in
  if (_userToken != null) {
    // library page functions
    if (index == 2) {
      // getting collections and playlist data stored in models

      // checking if the collections or playlists are empty
      if (Provider.of<LibraryTabData>(context, listen: false)
              .getUserCollections()
              .length ==
          0) {
        print("Get Collections");
        getMyCollections(context, _userToken);
      }
      if (Provider.of<LibraryTabData>(context, listen: false)
              .getUserPlaylists()
              .length ==
          0) {
        getMyPlaylists(context, _userToken);
      }
    }
  }
}
