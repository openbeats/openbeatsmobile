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
    return AppBar(
      title: Text(
        "Explore",
      ),
    );
  }
}
