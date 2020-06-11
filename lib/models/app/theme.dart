import '../../imports.dart';

class ApplicationTheme extends ChangeNotifier {
  ThemeData _themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFF32C2C),
    accentColor: Colors.redAccent,
  );

  // used to get the current theme
  ThemeData getCurrentTheme() {
    return _themeData;
  }
}
