import 'package:obsmobile/imports.dart';

// holds the appbar for the tab
Widget appBar() {
  return AppBar(
    title: Text("Explore"),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {},
      ),
    ],
  );
}

// holds the recently played title
Widget recentlyPlayedTitle() {
  return ListTile(
    dense: true,
    title: Text(
      "Recently Played",
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),
  );
}

// holds the loading widget for the page
Widget _loadingAnimation() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// holds the recently played widget view
Widget recentlyPlayedView() {
  return Consumer2<ExploreTabData, UserModel>(
    builder: (context, data, userModelData, child) {
      // getting the list of collections and loading flag and user name
      var _listOfSongs = userModelData.getRecentlyPlayedList();
      // print(_listOfSongs[0]);
      bool _loadingFlag = data.getRecentlyPlayedLoading();
      return Container(
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.height * 0.40
            : MediaQuery.of(context).size.height * 0.50,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: (_listOfSongs != null && _listOfSongs.length > 0)
              ? (_loadingFlag)
                  ? _loadingAnimation()
                  : ListView.builder(
                      padding: EdgeInsets.only(left: 12.0),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          _recentlyPlayedGridViewContainer(
                              context, index, data, userModelData),
                      itemCount:
                          (_listOfSongs == null) ? 0 : _listOfSongs.length,
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.boxOpen,
                        size: 40.0,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "You do not seem \n to have any recently played songs",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 20.0),
                      )
                    ],
                  ),
                ),
        ),
      );
    },
  );
}

// holds the container used to build the collections gridview
Widget _recentlyPlayedGridViewContainer(BuildContext context, int index,
    ExploreTabData data, UserModel userModelData) {
  return GestureDetector(
    onTap: () {
      // functions.navigateToPlaylistView(
      //     context,
      //     {
      //       "playlistName": data.getUserCollections()["data"][index]["name"],
      //       "playlistId": data.getUserCollections()["data"][index]["_id"],
      //       "thumbnail": data.getUserCollections()["data"][index]["thumbnail"]
      //     },
      //     true);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          child: Container(
            width: MediaQuery.of(context).size.height * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            child: cachedNetworkImageW(
                userModelData.getRecentlyPlayedList()[index]["thumbnail"],
                60.0),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.only(left: 5.0),
          child: SizedBox(
            width: 140.0,
            child: Text(
              userModelData.getRecentlyPlayedList()[index]["name"],
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
                  userModelData
                      .getRecentlyPlayedList()[index]["popularityCount"]
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
    ),
  );
}
