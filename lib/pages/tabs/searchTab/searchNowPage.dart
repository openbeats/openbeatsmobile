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
      key: searchNowPageScaffoldKey,
      appBar: _searchNowPageAppBar(),
      body: _searchNowPageBody(),
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
          onChanged: (String value) async {
            data.setCurrentSearchString(value);
            getSearchSuggestion(context);
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

  // holds the search suggestions listview
  Widget _searchSuggestionsListBuilder(BuildContext context, int index) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(Provider.of<SearchTabModel>(context, listen: false)
          .getSearchSuggestions()[index][0]),
    );
  }

  // holds the searchNowPage body
  Widget _searchNowPageBody() {
    return Container(
      child:
          (Provider.of<SearchTabModel>(context).getSearchSuggestions().length !=
                  0)
              ? ListView.builder(
                  itemBuilder: _searchSuggestionsListBuilder,
                  itemCount: Provider.of<SearchTabModel>(context)
                      .getSearchSuggestions()
                      .length,
                )
              : null,
    );
  }
}
