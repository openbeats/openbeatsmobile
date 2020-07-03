import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import './functions.dart' as functions;

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar(),
      body: _exploreTabBody(),
    );
  }

  // holds the body of the exploreTab
  Widget _exploreTabBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        widgets.recentlyPlayedTitle(),
        // widgets.recentlyPlayedView(),
      ],
    );
  }
}
