import '../imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // print debug message
    DebugFunctions().printMessage("=======HOMEPAGE BUILD=======");
    return Scaffold(
      body: _homePageBody(),
    );
  }

  // holds the homePage body
  Widget _homePageBody() => Container(
        child: Center(
          child: Text("Hi there"),
        ),
      );
}
