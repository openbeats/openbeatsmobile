import 'package:obsmobile/imports.dart';

class GlobalThemes {
  // holds the theme data for the application
  ThemeData _themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF14161C),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      actionsIconTheme: IconThemeData(
        size: 24.0,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
      ),
    ),
    primaryColor: Color(0xFFF32C2C),
    accentColor: Colors.redAccent,
    primarySwatch: Colors.red,
    bottomAppBarColor: Color(0xFF212229),
  );

  // holds the theme data for the toast messages
  Map<String, dynamic> _toastThemeData = {
    "backgroundColor": Colors.blue,
    "position": ToastPosition.bottom,
    "duration": Duration(seconds: 5),
    "textPadding": EdgeInsets.all(20.0),
    "dismissOtherOnShow": true,
  };

  // used to get the app theme data
  ThemeData getAppTheme() => _themeData;
  // used to get the toast theme data
  Map<String, dynamic> getToastTheme() => _toastThemeData;
}
