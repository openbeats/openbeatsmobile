import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';
import '../widgets/authPageW.dart' as authPageW;
import '../globalVars.dart' as globalVars;
import '../actions/globalVarsA.dart' as globalVarsA;
import '../globalWids.dart' as globalWids;
import '../globalFun.dart' as globalFun;

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>(),
      _signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _authPageScaffoldKey =
      new GlobalKey<ScaffoldState>();
  bool _autoValidateLogin = false,
      _autoValidateSignUp = false,
      _isAuthenticating = false,
      _isSigningUp = false;
  String _emailID, _name, _password;
  final TextEditingController _passwordController = TextEditingController();

  void setLoginParmeters(body) {
    Map<String, dynamic> loginParameters = {
      "loginStatus": true,
      "userEmail": body["email"],
      "userName": body["name"],
      "userId": body["id"],
      "userAvatar": body["avatar"],
      "userToken": body["token"],
    };
    // true to alert the function to update the sharedPreferences
    globalVarsA.modifyLoginInfo(loginParameters, true);
  }

  void _attemptLogin() async {
    showSnackBarMessage(0);
    _emailID = _emailID.trim();
    _password = _password.trim();
    try {
      var response = await http.post("https://api.openbeats.live/auth/login",
          body: {"email": "$_emailID", "password": "$_password"});
      final body = json.decode(response.body);
      if (body["error"] == null) {
        _authPageScaffoldKey.currentState.removeCurrentSnackBar();
        setLoginParmeters(body);
        Navigator.pop(context);
        globalFun.showToastMessage("Welcome to OpenBeats");
      } else {
        showSnackBarMessage(1);
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (err) {
      print(err);
      showSnackBarMessage(5);
    }
  }

  void _attemptSignUp() async {
    _emailID = _emailID.trim();
    _password = _password.trim();
    _name = _name.trim();
    _password = _password.trim();
    showSnackBarMessage(2);
    try {
      var response = await http.post("https://api.openbeats.live/auth/register",
          body: {
            "email": "$_emailID",
            "password": "$_password",
            "name": "$_name"
          });
      final body = json.decode(response.body);
      if (body["error"] == null) {
        _authPageScaffoldKey.currentState.removeCurrentSnackBar();
        showSnackBarMessage(3);
        setState(() {
          _isSigningUp = false;
        });
      } else {
        showSnackBarMessage(4);
        setState(() {
          _isSigningUp = false;
        });
      }
    } catch (err) {
      print(err);
      showSnackBarMessage(5);
    }
  }

  void _validateLoginInputs() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      _attemptLogin();
    } else {
      setState(() {
        _autoValidateLogin = true;
        _isAuthenticating = false;
      });
    }
  }

  void _validateSignUpInputs() {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();
      _attemptSignUp();
    } else {
      setState(() {
        setState(() {
          _autoValidateSignUp = true;
          _isSigningUp = false;
        });
      });
    }
  }

  // shows status snackBars
  void showSnackBarMessage(int mode) {
    // holds the message to display
    String snackBarMessage;
    // flag to indicate if snackbar action has to be shown
    // flag to indicate if CircularProgressIndicatior must be shown
    bool showLoadingAnim = true;
    // holds color of snackBar
    Color snackBarColor;
    // duration of snackBar
    Duration snackBarDuration = Duration(minutes: 1);
    switch (mode) {
      case 0:
        snackBarMessage = "Authenticating user...";
        snackBarColor = Colors.orange;
        snackBarDuration = Duration(seconds: 30);
        break;
      case 1:
        snackBarMessage = "Aplogies. Invalid Credentials";
        snackBarColor = Colors.red;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 2:
        snackBarMessage = "Signing you up...";
        snackBarColor = Colors.orange;
        snackBarDuration = Duration(seconds: 30);
        break;
      case 3:
        snackBarMessage = "Success! Please login with your credentials";
        snackBarColor = globalVars.accentGreen;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 5);
        break;
      case 4:
        snackBarMessage =
            "Apologies, we already have an account with that email Id";
        snackBarColor = Colors.orange;
        showLoadingAnim = false;
        snackBarDuration = Duration(seconds: 5);
        break;
    }
    SnackBar statusSnackBar;
    if (mode != 5) {
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
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
      setState(() {
        _isAuthenticating = false;
        _isSigningUp = false;
      });
    }
    // removing any previous snackBar
    _authPageScaffoldKey.currentState.removeCurrentSnackBar();
    // showing new snackBar
    _authPageScaffoldKey.currentState.showSnackBar(statusSnackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _authPageScaffoldKey,
        appBar: authPageW.appBarW(_tabController),
        backgroundColor: globalVars.primaryDark,
        body: TabBarView(
          controller: _tabController,
          children: [loginPageBody(), signUpPageBody()],
        ),
      ),
    );
  }

  Widget loginPageBody() {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 4),
          ColorTween(begin: Color(0xff396afc), end: Color(0xFF000428))),
      Track("color2").add(Duration(seconds: 4),
          ColorTween(begin: Color(0xff2948ff), end: Color(0xFF004e92)))
    ]);
    return ControlledAnimation(
        playback: Playback.MIRROR,
        tween: tween,
        duration: tween.duration,
        builder: (context, animation) {
          return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [animation["color1"], animation["color2"]])),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _loginFormKey,
                  autovalidate: _autoValidateLogin,
                  child: Center(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                        ),
                        authPageW.loginImageView(context),
                        SizedBox(
                          height: 50.0,
                        ),
                        emailIdField(),
                        SizedBox(
                          height: 20.0,
                        ),
                        passwordField(false),
                        SizedBox(
                          height: 30.0,
                        ),
                        loginBtn()
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  Widget signUpPageBody() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _signUpFormKey,
          autovalidate: _autoValidateSignUp,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              authPageW.welcomeText(),
              SizedBox(
                height: 40.0,
              ),
              emailIdField(),
              SizedBox(
                height: 10.0,
              ),
              nameField(),
              SizedBox(
                height: 10.0,
              ),
              passwordField(true),
              SizedBox(
                height: 10.0,
              ),
              passwordConfirmField(),
              SizedBox(
                height: 40.0,
              ),
              signUpBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailIdField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        textInputAction: TextInputAction.done,
        cursorColor: globalVars.accentRed,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Your Email ID",
            errorStyle: TextStyle(color: Colors.orange)),
        validator: (String arg) {
          if (arg.length == 0)
            return 'Please enter your email ID';
          else if (!arg.contains("@"))
            return 'Please enter a valid email ID';
          else
            return null;
        },
        onSaved: (String val) {
          _emailID = val;
        },
      ),
    );
  }

  Widget passwordField(haveController) {
    return Container(
      child: TextFormField(
        controller: (haveController) ? _passwordController : null,
        obscureText: true,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: 18.0),
        cursorColor: globalVars.accentRed,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Your Password",
            errorStyle: TextStyle(color: Colors.orange)),
        validator: (String arg) {
          if (arg.length == 0)
            return 'Please enter your password';
          else
            return null;
        },
        onSaved: (String val) {
          _password = val;
        },
      ),
    );
  }

  Widget loginBtn() {
    return Container(
      child: RaisedButton(
        onPressed: (_isAuthenticating)
            ? null
            : () {
                setState(() {
                  _isAuthenticating = true;
                });
                _validateLoginInputs();
              },
        shape: StadiumBorder(),
        padding: EdgeInsets.all(20.0),
        color: globalVars.accentWhite,
        textColor: globalVars.accentRed,
        disabledColor: globalVars.accentWhite,
        child: (_isAuthenticating)
            ? SizedBox(
                height: 22.0,
                width: 22.0,
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(globalVars.accentRed)),
              )
            : Text(
                "Proceed to Login",
                style: TextStyle(fontSize: 18.0),
              ),
      ),
    );
  }

  Widget signUpBtn() {
    return Container(
      child: RaisedButton(
        onPressed: (_isSigningUp)
            ? null
            : () {
                setState(() {
                  _isSigningUp = true;
                });
                _validateSignUpInputs();
              },
        shape: StadiumBorder(),
        padding: EdgeInsets.all(20.0),
        color: globalVars.accentWhite,
        textColor: globalVars.accentRed,
        disabledColor: globalVars.accentWhite,
        child: (_isSigningUp)
            ? SizedBox(
                height: 22.0,
                width: 22.0,
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(globalVars.accentRed)),
              )
            : Text(
                "Sign Me Up!",
                style: TextStyle(fontSize: 18.0),
              ),
      ),
    );
  }

  Widget nameField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        textInputAction: TextInputAction.done,
        cursorColor: globalVars.accentRed,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Your Name",
            errorStyle: TextStyle(color: Colors.orange)),
        validator: (String arg) {
          if (arg.length == 0)
            return 'Please enter your name';
          else
            return null;
        },
        onSaved: (String val) {
          _name = val;
        },
      ),
    );
  }

  Widget passwordConfirmField() {
    return Container(
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        obscureText: true,
        textInputAction: TextInputAction.next,
        cursorColor: globalVars.accentRed,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Confirm your password",
            errorStyle: TextStyle(color: Colors.orange)),
        validator: (String arg) {
          if (arg.length == 0)
            return 'Please confirm your password';
          else if (_passwordController.text != arg)
            return 'Passwords do not match';
          else
            return null;
        },
      ),
    );
  }
}
