import '../../imports.dart';

class ApplicationTheme extends ChangeNotifier {
  ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFF32C2C),
    accentColor: Colors.redAccent,
  );
}
