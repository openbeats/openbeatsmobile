import 'package:openbeatsmobile/functions/searchPage/searchPageFunctions.dart';
import 'package:openbeatsmobile/imports.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchPageAppBar(),
    );
  }

  Widget _searchPageAppBar() {
    // getting the appBar theme
    AppBarTheme appBarTheme = ThemeComponents().getAppTheme().appBarTheme;
    return AppBar(
      title: Text(
        "Search",
        style: TextStyle(
          color: allDestinations[1].color,
          fontSize: appBarTheme.textTheme.headline6.fontSize,
          fontWeight: appBarTheme.textTheme.headline6.fontWeight,
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () => navigateToSearchNowView(context)),
      ],
    );
  }
}
