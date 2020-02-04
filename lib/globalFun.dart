import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import 'package:openbeatsmobile/pages/settingsPage.dart';
import 'package:openbeatsmobile/pages/topChartsPage.dart';
import 'package:openbeatsmobile/pages/yourPlaylistsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './globalVars.dart' as globalVars;
import './actions/globalVarsA.dart' as globalVarsA;
import './globalWids.dart' as globalWids;

// holds the drawer for the application
// currPage
// 1 - homePage
// 2 - topChartsPage
// 3 - artistsPage
// 4 - albumsPage
// 5 - historyPage
// 6 - yourPlaylistsPage
// 7 - likedSongsPage
// 8 - yourDownloadsPage
// 9 - settingsPage
Widget drawerW(int currPage, context) {
  return Drawer(
    child: Container(
      color: globalVars.primaryDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(context),
          drawerHomePageListTile(currPage, context),
          drawerTopChartsPageListTile(currPage, context),
          drawerArtistsPageListTile(currPage, context),
          drawerAlbumsPageListTile(currPage, context),
          drawerHistoryPageListTile(currPage, context),
          drawerYourPlaylistsPageListTile(currPage, context),
          drawerLikedSongsPageListTile(currPage, context),
          drawerYourDownloadsPageListTile(currPage, context),
          // drawerappsettingsPageListTile(currPage, context),
          drawerLogoutPageListTile(context),
        ],
      ),
    ),
  );
}

// holds the drawerHeader
Widget drawerHeader(context) {
  String userAvatar = globalVars.loginInfo["userAvatar"];
  if (userAvatar != "user_avatar")
    userAvatar = "http://" + userAvatar.substring(2, userAvatar.length);
  else
    userAvatar = "https://picsum.photos/200";
  return (globalVars.loginInfo["loginStatus"])
      ? UserAccountsDrawerHeader(
          accountName: Text(
            globalVars.loginInfo["userName"],
            style: TextStyle(color: globalVars.primaryLight),
          ),
          accountEmail: Text(
            globalVars.loginInfo["userEmail"],
            style: TextStyle(color: globalVars.primaryLight),
          ),
          decoration: BoxDecoration(color: globalVars.primaryDark),
          currentAccountPicture: CircleAvatar(
            backgroundColor: globalVars.accentWhite,
            child: CachedNetworkImage(
              imageUrl: userAvatar,
              placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(globalVars.accentRed)),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        )
      : SizedBox(
          height: 70.0,
          child: Container(
            child: RaisedButton(
              child: Text(
                "Login/SignUp\nto access exciting features",
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/authPage');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(globalVars.borderRadius))),
            ),
          ),
        );
}

// holds the homePage listTile for the drawer
Widget drawerHomePageListTile(int currPage, context) {
  return Container(
    child: (currPage != 1)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.home, color: globalVars.leadingIconColor),
            title: Text('Home',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Go back to the home page",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.of(context).pushReplacement(
                  globalWids.FadeRouteBuilder(page: HomePage()));
            },
          )
        : null,
  );
}

// holds the topChartsPage listTile for the drawer
Widget drawerTopChartsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 2)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.chartLine,
                color: globalVars.leadingIconColor),
            title: Text('Top Charts',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Listen to what's trending",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to homePage
              Navigator.of(context).pushReplacement(
                  globalWids.FadeRouteBuilder(page: TopChartsPage()));
            },
          )
        : null,
  );
}

// holds the artistsPage listTile for the drawer
Widget drawerArtistsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 3)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.users,
                color: globalVars.leadingIconColor),
            title: Text('Artists',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Songs from your favorite artists",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // // navigating to homePage
              // Navigator.pushReplacementNamed(context, '/artistsPage');
              showUnderDevToast();
            },
          )
        : null,
  );
}

// holds the albumsPage listTile for the drawer
Widget drawerAlbumsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 4)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.solidClone,
                color: globalVars.leadingIconColor),
            title: Text('Albums',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Browse the albums you love",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // // navigating to homePage
              // Navigator.pushReplacementNamed(context, '/albumsPage');
              showUnderDevToast();
            },
          )
        : null,
  );
}

// holds the historyPage listTile for the drawer
Widget drawerHistoryPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 5)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.history,
                color: globalVars.leadingIconColor),
            title: Text('Recently Played',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Your own music history",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // if (globalVars.loginInfo["loginStatus"] == true) {
              //   // navigating to homePage
              //   Navigator.pushReplacementNamed(context, '/historyPage');
              // } else {
              //   showToastMessage(
              //       "Please login to use feature", Colors.black, Colors.white);
              //   Navigator.pushNamed(context, '/authPage');
              // }
              showUnderDevToast();
            },
          )
        : null,
  );
}

// holds the yourPlaylistsPage listTile for the drawer
Widget drawerYourPlaylistsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 6)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.list, color: globalVars.leadingIconColor),
            title: Text('Your Playlists',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Tune to your own collections",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              if (globalVars.loginInfo["loginStatus"] == true) {
                // navigating to homePage
                Navigator.of(context).pushReplacement(
                    globalWids.FadeRouteBuilder(page: YourPlaylistsPage()));
              } else {
                showToastMessage(
                    "Please login to use feature", Colors.black, Colors.white);
                Navigator.pushNamed(context, '/authPage');
              }
            },
          )
        : null,
  );
}

// holds the likedSongsPage listTile for the drawer
Widget drawerLikedSongsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 7)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.heart,
                color: globalVars.leadingIconColor),
            title: Text('Favorites',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("All your liked songs",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // if (globalVars.loginInfo["loginStatus"] == true) {
              //   // navigating to homePage
              //   Navigator.pushReplacementNamed(context, '/likedSongsPage');
              // } else {
              //   showToastMessage(
              //       "Please login to use feature", Colors.black, Colors.white);
              //   Navigator.pushNamed(context, '/authPage');
              // }
              showUnderDevToast();
            },
          )
        : null,
  );
}

// holds the yourDownloadsPage listTile for the drawer
Widget drawerYourDownloadsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 8)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.download,
                color: globalVars.leadingIconColor),
            title: Text('Your Downloads',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("All songs on local device",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // if (globalVars.loginInfo["loginStatus"] == true) {
              //   // navigating to homePage
              //   Navigator.pushReplacementNamed(context, '/yourDownloadsPage');
              // } else {
              //   showToastMessage(
              //       "Please login to use feature", Colors.black, Colors.white);
              //   Navigator.pushNamed(context, '/authPage');
              // }
              showUnderDevToast();
            },
          )
        : null,
  );
}

// holds the appsettings listTile for the drawer
Widget drawerappsettingsPageListTile(int currPage, context) {
  return Container(
    child: (currPage != 9)
        ? ListTile(
            leading:
                Icon(FontAwesomeIcons.cogs, color: globalVars.leadingIconColor),
            title: Text('Settings',
                style: TextStyle(
                    color: globalVars.titleTextColor,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text("Application related settings",
            //     style: TextStyle(color: globalVars.subtitleTextColor)),
            onTap: () {
              // navigating to settings Page
              Navigator.of(context).pushNamed('/settingsPage');
            },
          )
        : null,
  );
}

// holds the logout listTile for the drawer
Widget drawerLogoutPageListTile(context) {
  return Container(
    child: (globalVars.loginInfo["loginStatus"])
        ? ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt, color: Colors.redAccent),
            title: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: globalVars.primaryDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(globalVars.borderRadius))),
                      title: Text("Are you sure?"),
                      content:
                          Text("This action will sign you out of your account"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.transparent,
                          textColor: globalVars.accentGreen,
                        ),
                        FlatButton(
                          child: Text("Logout"),
                          onPressed: () {
                            Map<String, dynamic> loginParameters = {
                              "loginStatus": false,
                            };
                            globalVarsA.modifyLoginInfo(loginParameters, true);
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(
                                globalWids.FadeRouteBuilder(page: HomePage()));
                            showToastMessage("Logged out Successfully",
                                Colors.black, Colors.white);
                          },
                          color: Colors.transparent,
                          textColor: globalVars.accentRed,
                        ),
                      ],
                    );
                  });
            },
          )
        : null,
  );
}

// function to show ToastMessage
void showToastMessage(String message, Color bgColor, Color txtColor) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: 16.0);
}

// function to show snackBars
void showSnackBars(int mode, GlobalKey<ScaffoldState> scaffoldKey, context) {
  // holds the message to display
  String snackBarMessage;
  // flag to indicate if snackbar action has to be shown
  // 1 - permission action / 2 - download cancel
  int showAction = 0;
  // flag to indicate if CircularProgressIndicatior must be shown
  bool showLoadingAnim = true;
  // holds color of snackBar
  Color snackBarColor;
  // duration of snackBar
  Duration snackBarDuration = Duration(minutes: 1);
  switch (mode) {
    case 0:
      snackBarMessage = "Fetching your choice...";
      snackBarColor = Colors.orange;
      snackBarDuration = Duration(seconds: 30);
      break;
    case 1:
      snackBarMessage = "Adding song to playlist...";
      snackBarColor = Colors.orange;
      snackBarDuration = Duration(seconds: 30);
      break;
    case 2:
      snackBarMessage = "Authenticating user...";
      snackBarColor = Colors.orange;
      snackBarDuration = Duration(seconds: 30);
      break;
    case 3:
      snackBarMessage = "Apologies. Invalid Credentials";
      snackBarColor = Colors.red;
      showLoadingAnim = false;
      snackBarDuration = Duration(seconds: 5);
      break;
    case 4:
      snackBarMessage = "Signing you up...";
      snackBarColor = Colors.orange;
      snackBarDuration = Duration(seconds: 30);
      break;
    case 5:
      snackBarMessage = "Success! Please login with your credentials";
      snackBarColor = globalVars.accentGreen;
      showLoadingAnim = false;
      snackBarDuration = Duration(seconds: 5);
      break;
    case 6:
      snackBarMessage =
          "Apologies, we already have an account with that email Id";
      snackBarColor = Colors.orange;
      showLoadingAnim = false;
      snackBarDuration = Duration(seconds: 5);
      break;
    case 7:
      snackBarMessage = "Initializing playlist...";
      snackBarColor = Colors.orange;
      snackBarDuration = Duration(seconds: 30);
      break;
  }
  SnackBar statusSnackBar;
  if (mode != 10) {
    // constructing snackBar
    statusSnackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: (showLoadingAnim)
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    )
                  : SizedBox(
                      child: null,
                    )),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            child: Text(
              snackBarMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      backgroundColor: snackBarColor,
      duration: snackBarDuration,
    );
  } else {
    statusSnackBar = globalWids.networkErrorSBar;
  }
  // removing any previous snackBar
  scaffoldKey.currentState.removeCurrentSnackBar();
  // showing new snackBar
  scaffoldKey.currentState.showSnackBar(statusSnackBar);
}

// shows the under developement toast
void showUnderDevToast() {
  showToastMessage(
      "Feature under development\nBut hey, we appreciate your interest! 😃",
      Colors.blue,
      Colors.white);
}

// shows the toast related to queue management
void showQueueBasedToasts(int toastId) {
  switch (toastId) {
    case 0:
      showToastMessage("Adding song to queue...", Colors.orange, Colors.white);
      break;
    case 1:
      showToastMessage("Song added to queue", Colors.green, Colors.white);
      break;
  }
}

// shows the no internet toasts
void showNoInternetToast(){
  showToastMessage("Not able to connect to the internet", Colors.red, Colors.white);
}

// gets the search history from sharedPreferences
void getSearchHistory() async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> searchHistory = prefs.getStringList("searchStrings");
  if (searchHistory != null) {
    globalVars.searchHistory = searchHistory;
  }
}

// adds value to search history
void addToSearchHistory(String query) async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ((globalVars.searchHistory.length == 0) ||
      (globalVars.searchHistory[0] != query)) {
    globalVars.searchHistory.insert(0, query);
    prefs.setStringList("searchStrings", globalVars.searchHistory);
  }
}

// updates the search history sharedPrefs value
void updateSearchHistorySharedPrefs() async {
  // creating sharedPreferences instance
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("searchStrings", globalVars.searchHistory);
}

// returns the max duration of the media in milliseconds
int getDurationMillis(String audioDuration) {
  // variable holding max value
  double maxVal = 0;
  // holds the integerDurationList
  List durationLst = new List();
  // converting duration value into list
  List durationStringLst = audioDuration.toString().split(':');
  // converting list into integer
  durationStringLst.forEach((f) {
    durationLst.add(int.parse(f));
  });
  // creating seconds value based on the durationLst
  // looping through each value from last value
  for (int i = durationLst.length - 1; i > -1; i--) {
    // add seconds just as they are
    if (i == durationLst.length - 1)
      maxVal += durationLst[i] * 1000;
    // add minutes by multiplying with 60
    else if (i == durationLst.length - 2)
      maxVal += (60000 * durationLst[i]);
    // add hours by multiplying twice with 60
    else if (i == durationLst.length - 3) maxVal += (3600000 * durationLst[i]);
  }
  return maxVal.toInt();
}

// return the current duration string in min:sec for bottomSheet slider
String getCurrentTimeStamp(double totalSeconds) {
  // variables holding separated time
  String min, sec, hour;
  // holds the total seconds to help decide if I need to send hours or not at the end
  double totalSecondsPlaceHolder = totalSeconds;
  // check if it is greater than one hour
  if (totalSeconds > 3600) {
    // getting number of hours
    hour = ((totalSeconds % (24 * 3600)) / 3600).floor().toString();
    totalSeconds %= 3600;
  }
  // getting number of minutes
  min = (totalSeconds / 60).floor().toString();
  totalSeconds %= 60;
  // getting number of seconds
  sec = (totalSeconds).floor().toString();
  // adding the necessary zeros
  if (int.parse(sec) < 10) sec = "0" + sec;
  // if the duration is greater than 1 hour, return with hour
  if (totalSecondsPlaceHolder > 3600) {
    if (double.parse(min) < 10.0) {
      return (hour.toString() + ":0" + min.toString() + ":" + sec.toString());
    } else {
      return (hour.toString() + ":" + min.toString() + ":" + sec.toString());
    }
  } else {
    if (double.parse(min) < 10.0) {
      return ("0" + min.toString() + ":" + sec.toString());
    } else {
      return (min.toString() + ":" + sec.toString());
    }
  }
}

// method to show dialog
Future<dynamic> nativeMethodCallHandler(MethodCall methodCall, context) async {
  if (methodCall.method == "showRational") {
    var parameters = methodCall.arguments;
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Permission Required"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(globalVars.borderRadius))),
              backgroundColor: globalVars.primaryDark,
              content: Text(
                  "OpenBeats requires storage access permission to download and save the songs you would like to listen offline"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentRed,
                ),
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    globalVars.platformMethodChannel
                        .invokeMethod("startDownload", {
                      "videoId": parameters[0],
                      "videoTitle": parameters[1],
                      "showRational": true,
                    });
                  },
                  color: Colors.transparent,
                  textColor: globalVars.accentGreen,
                ),
              ],
            ));
  }
}

// showing the dialog to check if user wants to start playback or add song to queue
void showStopAndPlayChoice(context, getMp3URL, videosResponseItem, index) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: globalVars.primaryDark,
            title: Text("Are you sure?"),
            content: Text("This action will end the current media playback"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(globalVars.borderRadius))),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: globalVars.primaryDark,
                  textColor: Colors.grey,
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (AudioService.playbackState != null &&
                        AudioService.playbackState.basicState !=
                            BasicPlaybackState.none &&
                        AudioService.playbackState.basicState !=
                            BasicPlaybackState.stopped) {
                      showQueueBasedToasts(0);
                      var parameter = {"song": videosResponseItem};
                      AudioService.customAction("addItemToQueue", parameter);
                    } else {
                      showToastMessage("Please start a song to awail queue",
                          Colors.orange, Colors.white);
                    }
                  },
                  color: globalVars.primaryDark,
                  textColor: Colors.green,
                  child: Text("Add to Queue")),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await getMp3URL(videosResponseItem["videoId"], index);
                  },
                  color: globalVars.primaryDark,
                  textColor: Colors.orange,
                  child: Text("Continue")),
            ],
          ));
}
