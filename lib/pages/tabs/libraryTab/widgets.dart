import 'package:obsmobile/imports.dart';

// holds the appbar for library page
Widget appBar() {
  return AppBar(
    title: Text("Library"),
  );
}

// holds the loading widget for the page
Widget _loadingAnimation() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// holds the title for the collections gridview
Widget collectionsTitle() {
  return Container(
    padding: EdgeInsets.only(left: 5.0),
    child: Text(
      "Liked Collections",
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),
  );
}

// holds the collection gridview
Widget collectionGridView(BuildContext context) {
  return Consumer<LibraryTabData>(
    builder: (context, data, child) {
      // getting the list of collections and loading flag
      var _listOfCollections = data.getUserCollections()["data"];
      bool _loadingFlag = data.getUserCollectionLoadingFlag();
      return Container(
        height: MediaQuery.of(context).size.height * 0.40,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          child: (_loadingFlag)
              ? _loadingAnimation()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      _collectionsGridViewContainer(context, index, data),
                  itemCount: (_listOfCollections == null)
                      ? 0
                      : _listOfCollections.length,
                ),
        ),
      );
    },
  );
}

// holds the container used to build the collections gridview
Widget _collectionsGridViewContainer(
    BuildContext context, int index, LibraryTabData data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Card(
        child: Container(
          width: MediaQuery.of(context).size.height * 0.25,
          height: MediaQuery.of(context).size.height * 0.25,
          child: cachedNetworkImageW(
              data.getUserCollections()["data"][index]["thumbnail"]),
        ),
      ),
      SizedBox(height: 5.0),
      Container(
        padding: EdgeInsets.only(left: 5.0),
        child: SizedBox(
          width: 140.0,
          child: Text(
            data.getUserCollections()["data"][index]["name"],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
      ),
      SizedBox(height: 5.0),
      Container(
        padding: EdgeInsets.only(left: 5.0),
        child: SizedBox(
          width: 140.0,
          child: Text(
            "#" +
                data
                    .getUserCollections()["data"][index]["popularityCount"]
                    .toString() +
                " global plays",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.grey),
          ),
        ),
      )
    ],
  );
}

// holds the title for the playlists listview
Widget playlistTitle() {
  return Container(
    padding: EdgeInsets.only(left: 5.0),
    child: Text(
      "Your Playlists",
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),
  );
}

// holds the listview to show all user playlists
Widget playlistListView() {
  return Consumer<LibraryTabData>(builder: (context, data, child) {
    // getting the list of collections and loading flag
    var _listOfPlaylists = data.getUserPlaylists()["data"];
    bool _loadingFlag = data.getUserPlaylistLoadingFlag();
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: (_loadingFlag)
          ? Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: _loadingAnimation(),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount:
                  (_listOfPlaylists == null) ? 0 : _listOfPlaylists.length,
              itemBuilder: (BuildContext context, int index) =>
                  _playlistListViewContainer(context, index, data),
            ),
    );
  });
}

// holds the container used to build the listview builder
Widget _playlistListViewContainer(
    BuildContext context, int index, LibraryTabData data) {
  return ListTile(
    leading: Icon(Icons.music_note),
    title: Text(data.getUserPlaylists()["data"][index]["name"]),
    subtitle: Text(
        data.getUserPlaylists()["data"][index]["totalSongs"].toString() +
            " songs"),
    trailing: Icon(Icons.more_vert),
  );
}
