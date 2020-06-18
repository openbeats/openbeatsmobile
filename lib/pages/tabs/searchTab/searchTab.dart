import 'package:obsmobile/imports.dart';
import './functions.dart' as functions;
import './widgets.dart' as widgets;

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
      child: Consumer<SearchTabModel>(
        builder: (context, data, child) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: (data.getLoadingFlag())
                ? Center(
                    child: loadingAnimationW(),
                  )
                : (data.getSearchResults().length > 0)
                    ? searchResultsListView()
                    : widgets.searchInstructionW(context),
          );
        },
      ),
    );
  }

  // holds the search results listview
  Widget searchResultsListView() {
    return Container(
      child: ListView.builder(
        itemBuilder: searchResultsListBuilder,
        itemCount:
            Provider.of<SearchTabModel>(context).getSearchResults().length,
      ),
    );
  }

  // holds the searchResults builder widget
  Widget searchResultsListBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(Provider.of<SearchTabModel>(context).getSearchResults()[index]
          ["title"]),
    );
  }
}
