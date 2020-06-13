import '../../../imports.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _libraryPageAppBar(),
      body: Center(
        child: Text("Library Page"),
      ),
    );
  }

  Widget _libraryPageAppBar() {
    return AppBar(
      title: Text(
        "Library",
        style: TextStyle(
          color: allDestinations[2].color,
          fontSize: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontSize,
          fontWeight: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontWeight,
        ),
      ),
    );
  }
}
