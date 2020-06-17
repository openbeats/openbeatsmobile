import 'package:obsmobile/imports.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _searchTabBody(),
    );
  }

  // holds the body of searchTab
  Widget _searchTabBody(){
    return Container(
      child: Center(
        child: Text("Search Tab"),
      ),
    );
  }
}