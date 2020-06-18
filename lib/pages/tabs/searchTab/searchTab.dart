import 'package:obsmobile/imports.dart';
import './functions.dart' as functions;

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: searchTabScaffoldKey,
      appBar: _searchTabAppBar(),
      body: _searchTabBody(),
    );
  }

  // holds the appBar for the searchTab
  Widget _searchTabAppBar() {
    return AppBar(
      title: Text("Search"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => functions.navigateToSearchNowPage(context),
        ),
      ],
    );
  }

  // holds the body of searchTab
  Widget _searchTabBody() {
    return Container(
      child: Center(
        child: Text("Search Tab"),
      ),
    );
  }
}
