import '../../../imports.dart';

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
    return AppBar(
      title: Text(
        "Explore",
        style: TextStyle(
          color: allDestinations[0].color,
          fontSize: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontSize,
          fontWeight: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontWeight,
        ),
      ),
    );
  }
}
