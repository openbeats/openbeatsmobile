import 'package:openbeatsmobile/imports.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _libraryPageAppBar(),
    );
  }

  Widget _libraryPageAppBar() {
    // getting the appBar theme
    AppBarTheme appBarTheme = ThemeComponents().getAppTheme().appBarTheme;
    return AppBar(
      title: Text(
        "Library",
        style: TextStyle(
          color: allDestinations[2].color,
          fontSize: appBarTheme.textTheme.headline6.fontSize,
          fontWeight: appBarTheme.textTheme.headline6.fontWeight,
        ),
      ),
    );
  }
}
