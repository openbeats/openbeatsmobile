import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/helpUsPageW.dart' as helpUsPageW;
import '../globalVars.dart' as globalVars;
import '../globalFun.dart' as globalFun;

class BugReportPage extends StatefulWidget {
  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var deviceInfo;
  bool _isLoading = true, _autoValidate = false;
  String bugTitle, bugDesc;

  // verifies the bug report fields
  void validateFields() async {
    // validate all fields
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // creating URL to send mail
      String url =
          "mailto:openbeatsyag@gmail.com?subject=Bug Report: $bugTitle&body=<b>Device information:</b><br>${deviceInfo["deviceBrand"]} ${deviceInfo["deviceModel"]}<br>Api Level: ${deviceInfo["systemApi"]}<br>RAM: ${deviceInfo["systemRam"]}<br><br><b>Bug Description:</b><br>$bugDesc";
      if (await canLaunch(url)) {
        globalFun.showToastMessage("Please press Send", globalVars.accentGreen,
            globalVars.accentWhite);
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // gets the device information from the android side
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
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  bugQuote(),
                  SizedBox(height: 30.0),
                  deviceInfoTextBox(),
                  SizedBox(height: 20.0),
                  bugTitleTextBox(),
                  SizedBox(height: 20.0),
                  bugDescTextBox(),
                  SizedBox(height: 40.0),
                  submitBug()
                ],
              ),
            ),
    );
  }

  Widget bugQuote() {
    return Container(
      child: Text(
          "\"There are two ways to write error-free programs; only the third one works\"\n\n- Alan J. Perlis",
          style: TextStyle(
              fontFamily: "Comfortaa-Medium",
              fontSize: 16.0,
              color: Colors.grey, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center),
    );
  }

  Widget deviceInfoTextBox() {
    //  setting device brand in required format
    deviceInfo["deviceBrand"] =
        deviceInfo["deviceBrand"].toString()[0].toUpperCase() +
            deviceInfo["deviceBrand"].toString().substring(1);
    return Container(
      child: TextFormField(
        readOnly: true,
        maxLines: 3,
        decoration: InputDecoration(
            labelText: "Device Information",
            helperText: "Helps us reproduce your bug",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
            prefixIcon: Icon(Icons.perm_device_information)),
        initialValue: deviceInfo["deviceBrand"] +
            " " +
            deviceInfo["deviceModel"] +
            "\nApi Level: " +
            deviceInfo["systemApi"] +
            "\nRAM: " +
            deviceInfo["systemRam"],
      ),
    );
  }

  Widget bugTitleTextBox() {
    return Container(
      child: TextFormField(
          autovalidate: _autoValidate,
          autocorrect: true,
          textInputAction: TextInputAction.done,
          validator: (args) {
            if (args.length == 0)
              return "Please enter a name for the bug";
            else
              return null;
          },
          onSaved: (val) {
            bugTitle = val;
          },
          maxLength: 50,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Bug Title",
            helperText: "Helps us uniquely identify your bug",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
          )),
    );
  }

  Widget bugDescTextBox() {
    return Container(
      child: TextFormField(
          autovalidate: _autoValidate,
          autocorrect: true,
          textInputAction: TextInputAction.newline,
          validator: (args) {
            if (args.length == 0)
              return "Please enter description of the bug";
            else
              return null;
          },
          onSaved: (val) {
            bugDesc = val;
          },
          maxLength: 2000,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: "Bug Description",
            helperText: "Please be as descriptive as you can",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
          )),
    );
  }

  Widget submitBug() {
    return Container(
      child: RaisedButton(
        onPressed: validateFields,
        padding: EdgeInsets.all(20.0),
        child: Text("Send Bug Report"),
        color: globalVars.primaryLight,
        textColor: globalVars.primaryDark,
        shape: StadiumBorder(),
      ),
    );
  }
}
