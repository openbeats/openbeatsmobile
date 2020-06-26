import 'package:obsmobile/imports.dart';

// holds the appbar for library page
Widget appBar() {
  return AppBar(
    title: Text("Library"),
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
  return Consumer<UserModel>(
    builder: (context, data, child) {
      // getting the list of collections
      var _listOfCollections = data.getUserCollections()["data"];
      return Container(
        height: MediaQuery.of(context).size.height * 0.38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) =>
              _collectionsGridViewContainer(context, index, data),
          itemCount:
              (_listOfCollections == null) ? 0 : _listOfCollections.length,
        ),
      );
    },
  );
}

// holds the container used to build the collections gridview
Widget _collectionsGridViewContainer(
    BuildContext context, int index, UserModel data) {
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
