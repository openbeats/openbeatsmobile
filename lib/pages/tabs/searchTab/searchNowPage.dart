import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;

class SearchNowPage extends StatefulWidget {
  @override
  _SearchNowPageState createState() => _SearchNowPageState();
}

class _SearchNowPageState extends State<SearchNowPage> {
  // holds the TextEditingController for the search field
  TextEditingController _searchFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    // after state is initialized
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // filing the previous search string into the textfield
      _searchFieldController.text =
          Provider.of<SearchTabModel>(context, listen: false)
              .getCurrentSearchString();
      // adding listener to the search field
      _searchFieldController.addListener(() {
        // if the field is empty
        if (_searchFieldController.text.length == 0) {
          // clearing the searchSuggestions
          Provider.of<SearchTabModel>(context, listen: false)
              .updateSearchSuggestions([]);
          // setting the delayFlag to keep the queued updating of the searchSuggestions after we clear them
          Provider.of<SearchTabModel>(context, listen: false)
              .setDelayFlag(true);
        } else {
          // setting the delayFlag to let the searchSuggestions list to be updated
          Provider.of<SearchTabModel>(context, listen: false)
              .setDelayFlag(false);
        }
      });
    });
  }

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
      titleSpacing: 0.0,
      elevation: 0,
      title: _appBarTextField(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => Navigator.pop(context, _searchFieldController.text),
        )
      ],
    );
  }

  // holds the textfield for the AppBar
  Widget _appBarTextField() {
    return Consumer<SearchTabModel>(
      builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.only(left: 10.0),
          child: TextField(
            autofocus: true,
            textInputAction: TextInputAction.search,
            controller: _searchFieldController,
            cursorColor: GlobalThemes().getAppTheme().primaryColor,
            style: TextStyle(fontSize: 18.0),
            onChanged: (String value) async {
              Provider.of<SearchTabModel>(context, listen: false)
                  .setCurrentSearchString(value);
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
                      onTap: () {
                        Provider.of<SearchTabModel>(context, listen: false)
                            .setCurrentSearchString("");
                        WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _searchFieldController.clear());
                      },
                    ),
              hintText: "Search for songs, artists, audio books...",
            ),
          ),
        );
      },
    );
  }

  // holds the searchNowPage body
  Widget _searchNowPageBody() {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          (_searchFieldController.text.length == 0)
              ? widgets.suggestionsTitleW(true)
              : widgets.suggestionsTitleW(false),
          Container(
            child: (Provider.of<SearchTabModel>(context)
                            .getSearchHistory()
                            .length >
                        0 ||
                    _searchFieldController.text.length != 0)
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        (_searchFieldController.text.length == 0)
                            ? widgets.searchSuggestionsListBuilder(
                                context, index, true)
                            : widgets.searchSuggestionsListBuilder(
                                context, index, false),
                    itemCount: (_searchFieldController.text.length == 0)
                        ? Provider.of<SearchTabModel>(context)
                            .getSearchHistory()
                            .length
                        : Provider.of<SearchTabModel>(context)
                            .getSearchSuggestions()
                            .length,
                  )
                : Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Text(
                      "No previous searches",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
