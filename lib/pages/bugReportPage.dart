import 'package:flutter/material.dart';
import '../widgets/helpUsPageW.dart' as helpUsPageW;
import '../globalVars.dart' as globalVars;

class BugReportPage extends StatefulWidget {
  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  var deviceInfo;
  bool _isLoading = true;

  void getDeviceInfo() async {
    setState(() {
      _isLoading = true;
    });
    deviceInfo =
        await globalVars.platformMethodChannel.invokeMethod("getDeviceInfo");
    print(deviceInfo);
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
      alignment: Alignment.center,
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
        maxLines: 3,
        decoration: InputDecoration(
            labelText: "Device Information",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
            prefixIcon: Icon(Icons.perm_device_information)),
        initialValue: deviceInfo["deviceBrand"].toString()[0].toUpperCase() +
            deviceInfo["deviceBrand"].toString().substring(1) +
            " " +
            deviceInfo["deviceModel"] +
            "\nApi Level: " +
            deviceInfo["systemApi"] +
            "\nRAM: " +
            deviceInfo["systemRam"],
      ),
    );
  }
}
