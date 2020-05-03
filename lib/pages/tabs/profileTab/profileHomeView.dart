import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flutter/material.dart';

import '../../../widgets/tabW/profileTab/profileHomeViewW.dart'
    as profileHomeViewW;

import '../../../globals/globalColors.dart' as globalColors;

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

  // autoValidate flags for the forms
  bool signInFormAutoValidate = false, joinFormAutoValidate = false;

  // validator method for the textfields
  void textFieldValidator() {
    // checking the current tab
    if (authTabController.index == 0) {
      // validating signIn form
      if (_signInFormKey.currentState.validate())
        signInCallback();
      else {
        setState(() {
          signInFormAutoValidate = true;
        });
      }
    } else {
      if (_joinFormKey.currentState.validate())
        joinCallback();
      else {
        setState(() {
          joinFormAutoValidate = true;
        });
      }
    }
  }

  // signIn callback function
  void signInCallback() {
    // fetching values from controllers
    String userEmail = emailFieldController.text;
    String userPassword = passwordFieldController.text;
  }

  // join callback function
  void joinCallback() {
    // fetching values from controllers
    String userName = userNameFieldController.text;
    String userEmail = emailFieldController.text;
    String userPassword = passwordFieldController.text;
  }

  @override
  void initState() {
    super.initState();
    // setting header mode to show the right widget
    _headerMode = "auth";
    // initiating tabController
    authTabController = TabController(length: 2, vsync: this);
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
      children: <Widget>[
        authTabW(context, tabBarViewAuthTabW(context), authTabController)
      ],
    );
  }

  // holds the TabBarView for authTabW
  Widget tabBarViewAuthTabW(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: authTabController,
        children: <Widget>[
          _signInWTabBarViewAuthTabW(context),
          _joinWTabBarViewAuthTabW(context),
        ],
      ),
    );
  }

  // holds the authTabW
  Widget authTabW(BuildContext context, Widget tabBarViewAuthTabW,
      TabController authTabController) {
    return Column(
      children: <Widget>[
        _tabBarAuthTabW(authTabController),
        tabBarViewAuthTabW,
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
          profileHomeViewW.emailTxtField(
              context, true, emailFieldController, signInFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, true, passwordFieldController, signInFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          profileHomeViewW.actionBtnW(context, true, textFieldValidator),
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
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          profileHomeViewW.joinTabGreetingMessage(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          profileHomeViewW.userNameTextField(
              context, userNameFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.emailTxtField(
              context, false, emailFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, false, passwordFieldController, joinFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          profileHomeViewW.actionBtnW(context, false, textFieldValidator),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    );
  }
}
