import 'dart:convert';

import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/tabW/profileTab/profileHomeViewW.dart'
    as profileHomeViewW;
import '../../../globals/globalColors.dart' as globalColors;
import '../../../globals/globalVars.dart' as globalVars;
import '../../../globals/actions/globalVarsA.dart' as globalVarsA;
import '../../../globals/globalFun.dart' as globalFun;

class ProfileHomeView extends StatefulWidget {
  @override
  _ProfileHomeViewState createState() => _ProfileHomeViewState();
}

class _ProfileHomeViewState extends State<ProfileHomeView>
    with SingleTickerProviderStateMixin {
  // header mode to show
  String _headerMode;
  // dropDown banner navigator
  final _dropDownBannerNavigatorKey = GlobalKey<NavigatorState>();
  // form key for the textformfields
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();
  // controllers for the tabView
  TabController authTabController;
  // controllers for textfields
  TextEditingController userNameFieldController = new TextEditingController();
  TextEditingController emailFieldController = new TextEditingController();
  TextEditingController passwordFieldController = new TextEditingController();
  // is loading flag for http requests
  bool isLoading = false;
  // show or hide the password field data
  bool hidePasswordField = true;

  // toggles the visibility of the password field
  void togglePasswordVisibility() {
    setState(() {
      hidePasswordField = !hidePasswordField;
    });
  }

  // validator method for the textfields
  void textFieldValidator() {
    // validation passed
    bool validationPassed = true;
    // dismissing the keyboard
    FocusScope.of(context).unfocus();
    // checking the current tab
    if (authTabController.index == 1) {
      validationPassed = false;
      initiateDropDownBanner("Please enter your name", globalColors.warningClr,
          globalColors.darkBgTextClr, Duration(seconds: 3));
    } else {
      // check if all the fields are filled
      if (emailFieldController.text.length == 0) {
        validationPassed = false;
        // showing dropdown banner
        initiateDropDownBanner(
            "Please enter your email address",
            globalColors.warningClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      } else if (!emailFieldController.text.contains("@") ||
          !emailFieldController.text.contains(".")) {
        validationPassed = false;
        // showing dropdown banner
        initiateDropDownBanner(
            "Please enter valid email address",
            globalColors.warningClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      } else if (passwordFieldController.text.length == 0) {
        validationPassed = false;
        // showing dropdown banner
        initiateDropDownBanner(
            "Please enter your password",
            globalColors.warningClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      }
    }
    if (validationPassed)
      (authTabController == 0) ? signInCallback() : joinCallback();
  }

  // signIn callback function
  void signInCallback() async {
    setState(() {
      isLoading = true;
    });
    // fetching values from controllers
    String _userEmail = emailFieldController.text.trim();
    String _userPassword = passwordFieldController.text.trim();

    try {
      // sending http request
      var response = await http.post(globalVars.apiHostAddress + "/auth/login",
          body: {"email": _userEmail, "password": _userPassword});
      // converting response to JSON
      var responseJSON = jsonDecode(response.body);

      // fixing the avatar URL bug
      responseJSON["data"]["avatar"] = "http:" + responseJSON["data"]["avatar"];

      if (responseJSON["status"]) {
        // updating global reference
        globalVarsA
            .updateUserDetails(Map<String, String>.from(responseJSON["data"]));
        // adding token to shared preferences
        globalFun.updateUserDetailsSharedPrefs(
            Map<String, String>.from(responseJSON["data"]));
        setState(() {});
        // showing dropdown banner
        initiateDropDownBanner(
            "Welcome back, ${responseJSON["data"]["name"]}",
            globalColors.successClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
        // clear text fields
        emailFieldController.clear();
        passwordFieldController.clear();
      } else {
        // showing dropdown banner
        initiateDropDownBanner(
            "Apologies, please verify credentials",
            globalColors.errorClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 5));
      }
    } catch (e) {
      print(e);
      globalFun.showToastMessage("Unable to contact server", true,
          globalColors.errorClr, globalColors.darkBgTextClr);
    }
    // refreshing state
    setState(() {
      isLoading = false;
    });
  }

  // join callback function
  void joinCallback() async {
    setState(() {
      isLoading = true;
    });
    // fetching values from controllers
    String _userName = userNameFieldController.text.trim();
    String _userEmail = emailFieldController.text.trim();
    String _userPassword = passwordFieldController.text.trim();

    try {
      // sending http request
      var response = await http
          .post(globalVars.apiHostAddress + "/auth/register", body: {
        "name": _userName,
        "email": _userEmail,
        "password": _userPassword
      });
      // converting response to JSON
      var responseJSON = jsonDecode(response.body);
      if (responseJSON["status"]) {
        // updating global reference
        globalVarsA
            .updateUserDetails(Map<String, String>.from(responseJSON["data"]));
        // adding token to shared preferences
        globalFun.updateUserDetailsSharedPrefs(
            Map<String, String>.from(responseJSON["data"]));
        // showing dropdown banner
        initiateDropDownBanner(
            "Welcome to OpenBeats, ${responseJSON["data"]["name"]}",
            globalColors.successClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 3));
      } else if (responseJSON["data"] ==
          "User with that email id already exist") {
        // showing dropdown banner
        initiateDropDownBanner(
            "An user with the same email Id already exists",
            globalColors.errorClr,
            globalColors.darkBgTextClr,
            Duration(seconds: 5));
        // clearing text fields
        emailFieldController.clear();
        passwordFieldController.clear();
        userNameFieldController.clear();
      }
    } catch (e) {
      globalFun.showToastMessage("Unable to contact server", true,
          globalColors.errorClr, globalColors.darkBgTextClr);
    }
    setState(() {
      isLoading = false;
    });
  }

  // signout callback
  void signoutCallback() {
    // clearing local storage
    globalFun.clearUserDetailsSharedPrefs();
    // clearing global values
    globalVarsA.updateUserDetails(null);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // setting header mode to show the right widget
    _headerMode = "auth";
    // initiating tabController
    authTabController = TabController(length: 2, vsync: this);
  }

  // initiates the dropdownBanner
  void initiateDropDownBanner(
      String message, Color bgClr, Color txtClr, Duration showDuration) {
    DropdownBanner.showBanner(
        text: message,
        color: bgClr,
        duration: showDuration,
        textStyle: GoogleFonts.openSans(color: txtClr));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownBanner(
      child: Scaffold(
        appBar: profileHomeViewW.appBar(),
        body: profileHomeViewBody(),
      ),
      navigatorKey: _dropDownBannerNavigatorKey,
    );
  }

  // holds the body of ProfileHomeView
  Widget profileHomeViewBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[headerProfileHomeView()],
    );
  }

  // holds the header for the ProfileHomeView
  Widget headerProfileHomeView() {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: (globalVars.userDetails["token"] == null)
          ? authTabW()
          : profileHomeViewW.profileView(context, signoutCallback),
    );
  }

  // holds the TabBarView for authTabW
  Widget tabBarViewAuthTabW() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: TabBarView(
        controller: authTabController,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          _signInWTabBarViewAuthTabW(context),
          _joinWTabBarViewAuthTabW(context),
        ],
      ),
    );
  }

  // holds the authTabW
  Widget authTabW() {
    return Column(
      children: <Widget>[
        _tabBarAuthTabW(authTabController),
        tabBarViewAuthTabW(),
      ],
    );
  }

  // holds the tabBar for authTabW
  Widget _tabBarAuthTabW(TabController controller) {
    return TabBar(
        controller: controller,
        labelColor: globalColors.textActiveClr,
        unselectedLabelColor: globalColors.textDisabledClr,
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(text: "Sign In"),
          Tab(text: "Join"),
        ]);
  }

  // holds the signIn widgets for the authTabW
  Widget _signInWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          profileHomeViewW.signInTabGreetingMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0001,
          ),
          profileHomeViewW.signInTabGreetingSubtitleMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          profileHomeViewW.emailTxtField(context, true, emailFieldController),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context,
              true,
              passwordFieldController,
              hidePasswordField,
              togglePasswordVisibility),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.actionBtnW(
              context, true, textFieldValidator, isLoading),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.018,
          ),
          profileHomeViewW.fgtPasswordBtn(context),
        ],
      ),
    );
  }

// holds the sign up widgets for the authTabW
  Widget _joinWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _joinFormKey,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0,
          ),
          profileHomeViewW.joinTabGreetingMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          profileHomeViewW.userNameTextField(context, userNameFieldController),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.emailTxtField(context, false, emailFieldController),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context,
              false,
              passwordFieldController,
              hidePasswordField,
              togglePasswordVisibility),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.actionBtnW(
              context, false, textFieldValidator, isLoading),
        ],
      ),
    );
  }
}
