import 'package:obsmobile/imports.dart';
import './functions.dart' as functions;
import './widgets.dart' as widgets;

class LibraryTab extends StatefulWidget {
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar(),
      body: _libraryTabBody(),
    );
  }

  // holds the body for the searchTab
  Widget _libraryTabBody() {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 10.0),
          widgets.collectionsTitle(),
          SizedBox(height: 5.0),
          widgets.collectionGridView(context),
          SizedBox(height: 30.0),
          widgets.playlistTitle(),
          SizedBox(height: 5.0),
          widgets.playlistListView(),
          SizedBox(height: 200.0),
        ],
      ),
    );
  }
}
