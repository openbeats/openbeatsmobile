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
    trailing: GestureDetector(
      onTap: () {},
      child: Text("View All"),
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
      bool _loadingFlag = data.getRecentlyPlayedLoading();
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: (_loadingFlag)
            ? _loadingAnimation()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: _listOfSongs.length,
                itemBuilder: (context, index) =>
                    _recentlyPlayedGridViewContainer(
                        context, index, data, userModelData),
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
            width: MediaQuery.of(context).size.width * 0.37,
            height: MediaQuery.of(context).size.height * 0.20,
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
              userModelData.getRecentlyPlayedList()[index]["title"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        ),
      ],
    ),
  );
}
