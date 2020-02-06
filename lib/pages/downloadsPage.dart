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

class _DonwloadsPageState extends State<DonwloadsPage> {
  final GlobalKey<ScaffoldState> _downloadsPageScaffoldKey =
      new GlobalKey<ScaffoldState>();

  // holds the loading flag
  bool _isLoading = true, _hasPermission = false, _deniedPermission = false;  

  void checkPermissionStatus() async {
    
  }

  @override
  void initState() {
    super.initState();

    // check if app has storage permission
    checkPermissionStatus();
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
                ? (_hasPermission)
                    ? downloadsPageW.loadingAnimation()
                    : globalWids.noFileAccessView(checkPermissionStatus)
                : null,
          ),
        ),
      ),
    );
  }
}
