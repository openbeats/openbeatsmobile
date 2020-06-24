import 'package:obsmobile/imports.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _exploreTabBody(),
    );
  }

  // holds the body of the exploreTab
  Widget _exploreTabBody() {
    return Container(
      child: Center(
        child: Icon(Icons.music_note),
      ),
    );
  }
}
