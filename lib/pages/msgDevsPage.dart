import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/helpUsPageW.dart' as helpUsPageW;
import '../globalVars.dart' as globalVars;

class MsgDevsPage extends StatefulWidget {
  @override
  _MsgDevsPageState createState() => _MsgDevsPageState();
}

class _MsgDevsPageState extends State<MsgDevsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var deviceInfo;
  bool _autoValidate = false;
  String msgDevMessage;

  // verifies the msgDev report fields
  void validateFields() async {
    // validate all fields
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // creating URL to send mail
      String url =
          "mailto:openbeatsyag@gmail.com?subject=Message from ${globalVars.loginInfo["userEmail"]}&body=$msgDevMessage";
      if (await canLaunch(url)) {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: helpUsPageW.msgDevAppBarW(),
        backgroundColor: globalVars.primaryDark,
        body: msgDevBody(),
      ),
    );
  }

  Widget msgDevBody() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            msgDevQuote(),
            SizedBox(height: 30.0),
            msgDevDescTextBox(),
            SizedBox(height: 40.0),
            submitmsgDev()
          ],
        ),
      ),
    );
  }

  Widget msgDevQuote() {
    return Container(
      child: Text(
          "\"We all need people who will give us feedback. That’s how we improve\"\n\n- Bill Gates",
          style: TextStyle(
              fontFamily: "Comfortaa-Medium",
              fontSize: 16.0,
              color: Colors.grey,
              fontStyle: FontStyle.italic),
          textAlign: TextAlign.center),
    );
  }

  Widget msgDevDescTextBox() {
    return Container(
      child: TextFormField(
          autovalidate: _autoValidate,
          autocorrect: true,
          textInputAction: TextInputAction.newline,
          validator: (args) {
            if (args.length == 0)
              return "Please type the message you want to send to us";
            else
              return null;
          },
          onSaved: (val) {
            msgDevMessage = val;
          },
          maxLength: 2000,
          maxLines: 10,
          decoration: InputDecoration(
            labelText: "Message Description",
            helperText: "Please avoid sending us nagativity or profanity",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
          )),
    );
  }

  Widget submitmsgDev() {
    return Container(
      child: RaisedButton(
        onPressed: validateFields,
        padding: EdgeInsets.all(20.0),
        child: Text("Send Message"),
        color: globalVars.primaryLight,
        textColor: globalVars.primaryDark,
        shape: StadiumBorder(),
      ),
    );
  }
}
