import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/helpUsPageW.dart' as helpUsPageW;
import '../globalVars.dart' as globalVars;

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var deviceInfo;
  bool _autoValidate = false;
  String sugTitle, sugDesc;

  // verifies the sug report fields
  void validateFields() async {
    // validate all fields
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // creating URL to send mail
      String url =
          "mailto:openbeatsyag@gmail.com?subject=Suggestion: $sugTitle&body=$sugDesc";
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
        appBar: helpUsPageW.sugAppBarW(),
        backgroundColor: globalVars.primaryDark,
        body: sugBody(),
      ),
    );
  }

  Widget sugBody() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            sugTitleTextBox(),
            SizedBox(height: 20.0),
            sugDescTextBox(),
            SizedBox(height: 20.0),
            submitsug()
          ],
        ),
      ),
    );
  }

  Widget sugTitleTextBox() {
    return Container(
      child: TextFormField(
          autovalidate: _autoValidate,
          autofocus: true,
          autocorrect: true,
          textInputAction: TextInputAction.done,
          validator: (args) {
            if (args.length == 0)
              return "Please enter a title for your suggestion";
            else
              return null;
          },
          onSaved: (val) {
            sugTitle = val;
          },
          maxLength: 50,
          maxLines: null,
          decoration: InputDecoration(
            labelText: "Suggestion Title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
          )),
    );
  }

  Widget sugDescTextBox() {
    return Container(
      child: TextFormField(
          autovalidate: _autoValidate,
          autocorrect: true,
          textInputAction: TextInputAction.newline,
          validator: (args) {
            if (args.length == 0)
              return "Please enter description of the suggestion";
            else
              return null;
          },
          onSaved: (val) {
            sugDesc = val;
          },
          maxLength: 2000,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: "Suggestion Description",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(globalVars.borderRadius),
            ),
          )),
    );
  }

  Widget submitsug() {
    return Container(
      child: RaisedButton(
        onPressed: validateFields,
        padding: EdgeInsets.all(20.0),
        child: Text("Send Suggestion"),
        color: globalVars.primaryLight,
        textColor: globalVars.primaryDark,
        shape: StadiumBorder(),
      ),
    );
  }
}
