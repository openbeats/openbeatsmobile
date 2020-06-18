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
      height: MediaQuery.of(context).size.height,
      child: Consumer<SearchTabModel>(
        builder: (context, data, child) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: (data.getLoadingFlag())
                ? loadingAnimationW()
                : (data.getSearchResults().length > 0)
                    ? searchResultsListView(data)
                    : widgets.searchInstructionW(context),
          );
        },
      ),
    );
  }

  // holds the search results listview
  Widget searchResultsListView(SearchTabModel data) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 200.0),
        separatorBuilder: (context, index) => Divider(),
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            _searchResultsListBuilder(context, index, data),
        itemCount: data.getSearchResults().length,
      ),
    );
  }

  // holds the searchResults builder widget
  Widget _searchResultsListBuilder(
      BuildContext context, int index, SearchTabModel data) {
    return Container(
      child: ListTile(
        leading:
            cachedNetworkImageW(data.getSearchResults()[index]["thumbnail"]),
        title: Text(
          data.getSearchResults()[index]["title"],
          maxLines: 2,
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text("10M views"),
        ),
        trailing: GestureDetector(
          child: Icon(Icons.more_vert),
          onTap: () {
            print("MoreVert Tapped");
          },
        ),
      ),
    );
  }
}
