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
      appBar: widgets.appBar(context),
      body: _libraryTabBody(),
    );
  }

  // holds the body for the searchTab
  Widget _libraryTabBody() {
    return Consumer<UserModel>(
      builder: (context, data, child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: (data.getUserDetails()["name"] != null)
              ? ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    widgets.collectionsTitle(),
                    SizedBox(height: 5.0),
                    widgets.collectionGridView(context),
                    SizedBox(height: 5.0),
                    widgets.playlistTitle(),
                    widgets.playlistListView(),
                    SizedBox(height: 200.0),
                  ],
                )
              : widgets.libraryLoginAppeal(),
        );
      },
    );
  }
}
