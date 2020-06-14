import 'package:openbeatsmobile/imports.dart';

class AppComponents {
  // holds the api host address for the entire application
  String apiHostAddress = "https://staging-api.openbeats.live";

  // function to show snackBars
  void showSnackBars(GlobalKey<ScaffoldState> scaffoldKey, context,
      snackBarContent, snackBarBGColors, snackBarDuration) {
    // forming required snackbar
    SnackBar statusSnackBar = SnackBar(
      content: Text(snackBarContent),
      backgroundColor: snackBarBGColors,
      duration: snackBarDuration,
    );
    // removing any previous snackBar
    scaffoldKey.currentState.removeCurrentSnackBar();
    // showing new snackBar
    scaffoldKey.currentState.showSnackBar(statusSnackBar);
  }
}
