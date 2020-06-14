import '../../imports.dart';

class ScaffoldKeys extends ChangeNotifier {
  // index page
  final GlobalKey<ScaffoldState> _indexPage = new GlobalKey<ScaffoldState>();
  // search Page
  final GlobalKey<ScaffoldState> _searchPage = new GlobalKey<ScaffoldState>();

  // used to get the scaffold keys
  GlobalKey<ScaffoldState> getScaffoldKey(String page) {
    switch (page) {
      case "indexPage":
        return _indexPage;
      case "searchPage":
        return _searchPage;
      default:
    }
  }
}
