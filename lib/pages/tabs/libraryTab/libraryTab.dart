import 'package:obsmobile/imports.dart';

class LibraryTab extends StatefulWidget {
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _libraryTabBody(),
    );
  }

  // holds the body for the searchTab
  Widget _libraryTabBody() {
    return Container(
      child: Center(
        child: Text("Library Tab"),
      ),
    );
  }
}
