import 'package:obsmobile/imports.dart';

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
