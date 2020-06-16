import 'package:obsmobile/imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homePageBody(),
    );
  }

  // holds the body of the homePage
  Widget _homePageBody() {
    return Container(
      child: Center(
        child: Text("HomePage"),
      ),
    );
  }
}
