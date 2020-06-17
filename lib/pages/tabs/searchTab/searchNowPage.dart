import 'package:obsmobile/imports.dart';

class SearchNowPage extends StatefulWidget {
  @override
  _SearchNowPageState createState() => _SearchNowPageState();
}

class _SearchNowPageState extends State<SearchNowPage> {
  // holds the TextEditingController for the search field
  TextEditingController _searchFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchNowPageAppBar(),
    );
  }

  // holds the appBar for SearchNowPage
  Widget _searchNowPageAppBar() {
    return AppBar(
      title: _appBarTextField(),
    );
  }

  // holds the textfield for the AppBar
  Widget _appBarTextField() {
    return TextField(
      autofocus: true,
      controller: _searchFieldController,
      cursorColor: GlobalThemes().getAppTheme().primaryColor,
      style: TextStyle(fontSize: 18.0),
      decoration: InputDecoration.collapsed(
          hintText: "What do you want to listen today?"),
    );
  }
}
