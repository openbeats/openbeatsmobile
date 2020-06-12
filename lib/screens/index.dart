import '../imports.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _indexPageBody(),
      ),
    );
  }

  Widget _indexPageBody() {
    return Container(
      child: SlidingUpPanel(
        color: Provider.of<ApplicationTheme>(context).getBottomAppBarColor(),
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }
}
