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
    
    return AppBar(
      title: Text(
        "Library",
        
      ),
    );
  }
}
