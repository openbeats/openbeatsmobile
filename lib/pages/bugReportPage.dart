import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import '../widgets/helpUsPageW.dart' as helpUsPageW;
import '../globalVars.dart' as globalVars;

class BugReportPage extends StatefulWidget {
  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  // holds the android device information instance
  AndroidDeviceInfo androidInfo;
  bool _isLoading = true;

  void getDeviceInfo() async {
    setState(() {
      _isLoading = true;
    });
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: helpUsPageW.bugReportAppBarW(),
        backgroundColor: globalVars.primaryDark,
        body: bugReportingBody(),
      ),
    );
  }

  Widget bugReportingBody() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: (_isLoading)
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(globalVars.accentRed),
            )
          : ListView(
              children: <Widget>[
                SizedBox(height: 30.0),
                deviceInfoTextBox(),
              ],
            ),
    );
  }

  Widget deviceInfoTextBox() {
    return Container(
      child: TextFormField(
        enabled: false,
        maxLines: 2,
        decoration: InputDecoration(
            labelText: "Device Information",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
            prefixIcon: Icon(Icons.perm_device_information)),
        initialValue: androidInfo.manufacturer +
            " " +
            androidInfo.model +
            "\nSDK: " +
            androidInfo.version.sdkInt.toString() +
            "\n",
      ),
    );
  }
}
