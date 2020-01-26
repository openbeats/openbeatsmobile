import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:openbeatsmobile/pages/searchPage.dart';
import '../globalVars.dart' as globalVars;
import '../globalWids.dart' as globalWids;
import '../globalFun.dart' as globalFun;
import '../widgets/mainAppPageW.dart' as mainAppPageW;

class MainAppPage extends StatefulWidget {
  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  final GlobalKey<ScaffoldState> _homePageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // list to hold the list of video responses after query
  List videosResponseList = new List();
  // tells if the query requests have finished downloading
  bool searchResultLoading = false;

  // navigates to the search page
  void navigateToSearchPage() async {
    // setting navResult value to know if it has changed
    String selectedSearchResult = "";
    // Navigate to the search page and wait for response
    selectedSearchResult = await Navigator.of(context)
        .push(globalWids.FadeRouteBuilder(page: SearchPage()));
    // checking if the user has returned something
    if (selectedSearchResult != null && selectedSearchResult.length > 0) {
      // set the page to loading animation
      setState(() {
        searchResultLoading = true;
      });
      // calling function to get videos for query
      // getVideosForQuery(selectedSearchResult);
    }
  }

  // handles the back button press from exiting the app
  Future<bool> _onWillPop() {
    if (videosResponseList.length == 0)
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              backgroundColor: globalVars.primaryDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: new Text('Are you sure?'),
              content: new Text('Hope to see you again, soon! 😃'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Return to app'),
                ),
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: new Text(
                    'Exit app',
                    style: TextStyle(color: globalVars.accentRed),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    else
      setState(() {
        videosResponseList = [];
      });
  }

  // sets the status bar themes
  void setStatusTheme() async {
    await FlutterStatusbarcolor.setStatusBarColor(globalVars.primaryDark);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  @override
  void initState() {
    super.initState();
    setStatusTheme();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            key: _homePageScaffoldKey,
            backgroundColor: globalVars.primaryDark,
            appBar: mainAppPageW.appBarW(
                context, navigateToSearchPage, _homePageScaffoldKey),
            drawer: globalFun.drawerW(1, context),
            body: mainAppPageBody(),
          ),
        ));
  }

  Widget mainAppPageBody() {
    return Container(
      child: Center(
          child: (searchResultLoading)
              ? CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(globalVars.accentRed),
                )
              : (videosResponseList.length == 0)
                  ? mainAppPageW.homePageView()
                  : null),
    );
  }
}
