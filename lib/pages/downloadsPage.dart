import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openbeatsmobile/pages/homePage.dart';
import '../widgets/downloadsPageW.dart' as downloadsPageW;
import '../globalWids.dart' as globalWids;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;

class DonwloadsPage extends StatefulWidget {
  @override
  _DonwloadsPageState createState() => _DonwloadsPageState();
}

class _DonwloadsPageState extends State<DonwloadsPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _downloadsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // holds the loading flag
  bool _isLoading = true, _hasPermission = false, _noDownloadedFiles = true;
  // holds the list of songs in downloads
  List listOfSongs = new List();

  // gets the list of file in local storage
  void getListofFiles() async {
    setState(() {
      _isLoading = true;
    });
    // getting list of downloaded media
    listOfSongs = await globalVars.platformMethodChannel
        .invokeMethod("getListOfDownloadedAudio");
    if (listOfSongs[0] == "No Downloaded Files") {
      setState(() {
        _isLoading = false;
        _hasPermission = true;
        _noDownloadedFiles = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasPermission = true;
        _noDownloadedFiles = false;
      });
    }
  }

  // gets local storage permission
  void getPermission() async {
    // getting permission status result
    String result = await globalVars.platformMethodChannel
        .invokeMethod("getStoragePermission");
  }

  // checks current permission status
  void checksPermissionStatus() async {
    setState(() {
      _isLoading = true;
    });
    // getting permission status result
    String result = await globalVars.platformMethodChannel
        .invokeMethod("checkStoragePermission");
    if (result == "Access Granted") {
      getListofFiles();
      setState(() {
        _hasPermission = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasPermission = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // adding observer for checking when the user returns from settings page
    WidgetsBinding.instance.addObserver(this);
    // check if app has storage permission
    checksPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        checksPermissionStatus();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(globalWids.FadeRouteBuilder(page: HomePage()));
        //we need to return a future
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          key: _downloadsPageScaffoldKey,
          appBar: downloadsPageW.appBarW(context, _downloadsPageScaffoldKey),
          backgroundColor: globalVars.primaryDark,
          drawer: globalFun.drawerW(8, context),
          body: Container(
            child: (_isLoading)
                ? downloadsPageW.loadingAnimation()
                : (!_hasPermission)
                    ? globalWids.noFileAccessView(getPermission)
                    : (_noDownloadedFiles)
                        ? downloadsPageW
                            .noDownloadedFiles(checksPermissionStatus)
                        : listOfMedia(),
          ),
        ),
      ),
    );
  }

  Widget listOfMedia() {
    return ListView.builder(
      itemBuilder: listOfMediaBuilder,
      itemCount: listOfSongs.length,
      physics: BouncingScrollPhysics(),
    );
  }

  Widget listOfMediaBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ListTile(
        title: Text(listOfSongs[index].toString().replaceAll("@OpenBeats.mp3", "")),
        leading: Icon(Icons.music_note),
      ),
    );
  }
}
