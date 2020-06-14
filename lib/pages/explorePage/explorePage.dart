import 'package:openbeatsmobile/imports.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _explorePageAppBar(),
      body: Center(
        child: Text("Explore Page"),
      ),
    );
  }

  Widget _explorePageAppBar() {
    // getting the appBar theme
    AppBarTheme appBarTheme = ThemeComponents().getAppTheme().appBarTheme;
    return AppBar(
      title: Text(
        "Explore",
        style: TextStyle(
          color: allDestinations[0].color,
          fontSize: appBarTheme.textTheme.headline6.fontSize,
          fontWeight: appBarTheme.textTheme.headline6.fontWeight,
        ),
      ),
    );
  }
}
