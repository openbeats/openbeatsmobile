import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './globalVars.dart' as globalVars;

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
Widget drawerW(int currPage, context) {
  return Drawer(
    child: Container(
      color: globalVars.primaryDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(),
          drawerHomePageListTile(currPage, context),
          drawerTopChartsPageListTile(currPage, context),
          drawerArtistsPageListTile(currPage, context),
          drawerAlbumsPageListTile(currPage, context),
          drawerHistoryPageListTile(currPage, context),
          drawerYourPlaylistsPageListTile(currPage, context),
          drawerLikedSongsPageListTile(currPage, context),
          drawerYourDownloadsPageListTile(currPage, context),
          drawerappsettingsPageListTile(currPage,context),
        ],
      ),
    ),
  );
}

// holds the drawerHeader
Widget drawerHeader() {
  return UserAccountsDrawerHeader(
    accountName: Text(
      "Username",
      style: TextStyle(color: globalVars.primaryLight),
    ),
    accountEmail: Text(
      "youremail@email.com",
      style: TextStyle(color: globalVars.primaryLight),
    ),
    decoration: BoxDecoration(color: globalVars.primaryDark),
    currentAccountPicture: CircleAvatar(
      backgroundColor: globalVars.accentWhite,
      foregroundColor: globalVars.accentRed,
      child: Text(
        "R",
        style: TextStyle(fontSize: 40.0),
      ),
    ),
  );
}

// holds the homePage listTile for the drawer
Widget drawerHomePageListTile(int currPage, context) {
  return Container(
    child: (currPage != 1)
        ? ListTile(
            leading: Icon(FontAwesomeIcons.home),
            title: Text('Home'),
            subtitle: Text("Go back to the home page"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/homePage');
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
            leading: Icon(FontAwesomeIcons.chartLine),
            title: Text('Top Charts'),
            subtitle: Text("Listen to what's trending"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/topChartsPage');
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
            leading: Icon(FontAwesomeIcons.users),
            title: Text('Artists'),
            subtitle: Text("Songs from your favorite artists"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/artistsPage');
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
            leading: Icon(FontAwesomeIcons.solidClone),
            title: Text('Albums'),
            subtitle: Text("Browse the albums you love"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/albumsPage');
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
            leading: Icon(FontAwesomeIcons.history),
            title: Text('Recently Played'),
            subtitle: Text("Your own music history"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/historyPage');
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
            leading: Icon(FontAwesomeIcons.home),
            title: Text('Your Playlists'),
            subtitle: Text("Tune to your own collections"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/yourPlaylistsPage');
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
            leading: Icon(FontAwesomeIcons.heart),
            title: Text('Liked Songs'),
            subtitle: Text("All your liked songs"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/likedSongsPage');
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
            leading: Icon(FontAwesomeIcons.download),
            title: Text('Your Donwloads'),
            subtitle: Text("All songs on local device"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/yourDownloadsPage');
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
            leading: Icon(FontAwesomeIcons.cogs),
            title: Text('Settings'),
            subtitle: Text("Application related settings"),
            onTap: () {
              // navigating to homePage
              Navigator.pushReplacementNamed(context, '/appSettings');
            },
          )
        : null,
  );
}