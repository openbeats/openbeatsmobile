import '../../../imports.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageAppBar(),
      body: _searchPageBody(),
    );
  }

  Widget searchPageAppBar() {
    return AppBar(
      title: Text(
        "Search",
        style: TextStyle(
          color: Colors.cyan,
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _searchPageBody() {
    return Container(
      child: Center(
        child: Text("Search Page"),
      ),
    );
  }
}
