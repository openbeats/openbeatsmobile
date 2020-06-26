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
        height: MediaQuery.of(context).size.height * 0.3,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          scrollDirection: Axis.horizontal,
          itemCount:
              (_listOfCollections == null) ? 0 : _listOfCollections.length,
          itemBuilder: (BuildContext context, int index) =>
              _collectionsGridViewContainer(context, index, data),
        ),
      );
    },
  );
}

// holds the container used to build the collections gridview
Widget _collectionsGridViewContainer(
    BuildContext context, int index, UserModel data) {
  return Card(
    child: Container(
      height: double.infinity,
      width: double.infinity,
      child: cachedNetworkImageW(
          data.getUserCollections()["data"][index]["thumbnail"]),
    ),
  );
}
