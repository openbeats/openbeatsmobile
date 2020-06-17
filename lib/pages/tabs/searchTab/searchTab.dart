import 'package:obsmobile/imports.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () => Navigator.pushNamed(context, "/searchNowPage"),
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
