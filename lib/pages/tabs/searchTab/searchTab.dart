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
            duration: Duration(milliseconds: 600),
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
      child: StreamBuilder(
          stream: AudioService.currentMediaItemStream,
          builder: (context, snapshot) {
            MediaItem _currMediaItem = snapshot.data;
            return ListView.separated(
              padding: EdgeInsets.only(bottom: 200.0),
              separatorBuilder: (context, index) => Divider(),
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) =>
                  _searchResultsListBuilder(
                      context, index, data, _currMediaItem),
              itemCount: data.getSearchResults().length,
            );
          }),
    );
  }

  // holds the searchResults builder widget
  Widget _searchResultsListBuilder(BuildContext context, int index,
      SearchTabModel data, MediaItem _currMediaItem) {
    // check if this song is the current playing song
    bool _isPlaying = (_currMediaItem != null &&
        _currMediaItem.extras["vidId"] ==
            data.getSearchResults()[index]["videoId"] &&
        _currMediaItem.extras["playlist"] == "false");
    return Container(
      child: ListTile(
        selected: _isPlaying,
        onTap: () => (_isPlaying)
            ? getSlidingUpPanelController().open()
            : functions.startSingleSongPlayback(data, index),
        leading: cachedNetworkImageW(
            data.getSearchResults()[index]["thumbnail"], 60.0),
        title: Text(
          data.getSearchResults()[index]["title"],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14.0),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(data.getSearchResults()[index]["duration"] +
              " • " +
              reformatViewstoHumanReadable(
                  data.getSearchResults()[index]["views"])),
        ),
        trailing: GestureDetector(
          child: Icon(Icons.more_vert),
          onTap: () {
            showModalBottomSheet(
                context: homePageScaffoldKey.currentContext,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                ),
                backgroundColor: GlobalThemes().getAppTheme().bottomAppBarColor,
                builder: (BuildContext bc) {
                  return Container(
                    child: new Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          alignment: Alignment.center,
                          child: cachedNetworkImageW(
                              data.getSearchResults()[index]["thumbnail"],
                              100.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          width: 200.0,
                          child: Text(
                            data.getSearchResults()[index]["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: new Icon(Icons.playlist_add),
                          title: new Text('Add to Playlist'),
                          onTap: () {
                            Navigator.pop(bc);
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.queue),
                          title: new Text('Add to Queue'),
                          onTap: () {
                            Navigator.pop(bc);
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.share),
                          title: new Text('Share'),
                          onTap: () {
                            Navigator.pop(bc);
                          },
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
