import '../imports.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  @override
  Widget build(BuildContext context) {
    print("==============BUILT INDEX============-");
    return ChangeNotifierProvider<ApplicationState>(
      create: (_) => ApplicationState(),
      child: Scaffold(
        body: SafeArea(
          child: _indexPageBody(),
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  Widget _bottomNavBar() {
    return Consumer<ApplicationState>(
      builder: (context, data, _) => BottomNavigationBar(
        onTap: (tappedIndex) =>
            Provider.of<ApplicationState>(context, listen: false)
                .setBottomNavBarCurrentIndex(tappedIndex),
        currentIndex: Provider.of<ApplicationState>(context)
            .getBottomNavBarCurrentIndex(),
        backgroundColor:
            Provider.of<ApplicationTheme>(context).getBottomAppBarColor(),
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              backgroundColor: destination.color,
              title: Text(destination.title));
        }).toList(),
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
