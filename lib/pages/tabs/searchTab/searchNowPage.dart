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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );
  }

  // holds the textfield for the AppBar
  Widget _appBarTextField() {
    return Consumer<SearchTabModel>(
      builder: (context, data, child) {
        return TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          controller: _searchFieldController,
          cursorColor: GlobalThemes().getAppTheme().primaryColor,
          style: TextStyle(fontSize: 18.0),
          onChanged: (String value) {
            data.setCurrentSearchString(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: (_searchFieldController.text.length == 0)
                ? null
                : GestureDetector(
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onTap: () {},
                  ),
            hintText: "Search for songs, artists, audio books...",
          ),
        );
      },
    );
  }
}
