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
