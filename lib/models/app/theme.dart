import '../../imports.dart';

class ApplicationTheme extends ChangeNotifier {
  ThemeData _themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF14161C),
    primaryColor: Color(0xFFF32C2C),
    accentColor: Colors.redAccent,
    bottomAppBarColor: Color(0xFF212229),
  );

  // used to get the current theme
  ThemeData getCurrentTheme() => _themeData;
  // used to get the primary color
  Color getPrimaryColor() => _themeData.primaryColor;
  // used to get the accent color
  Color getAccentColor() => _themeData.accentColor;
  // used to get the bottomNavBarColor
  Color getBottomAppBarColor() => _themeData.bottomAppBarColor;
}
