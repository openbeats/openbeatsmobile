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
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  // controllers for the tabView
  TabController authTabController;
  // controllers for textfields
  TextEditingController userNameFieldController = new TextEditingController();
  TextEditingController emailFieldController = new TextEditingController();
  TextEditingController passwordFieldController = new TextEditingController();

  // autoValidate flags for the forms
  bool loginFormAutoValidate = false, signUpFormAutoValidate = false;

  // validator method for the textfields
  void textFieldValidator() {
    // checking the current tab
    if (authTabController.index == 0) {
      // validating login form
      if (_loginFormKey.currentState.validate())
        loginCallback();
      else {
        setState(() {
          loginFormAutoValidate = true;
        });
      }
    } else {
      if (_signUpFormKey.currentState.validate())
        signUpCallback();
      else {
        setState(() {
          signUpFormAutoValidate = true;
        });
      }
    }
  }

  // login callback function
  void loginCallback() {
    // fetching values from controllers
    String userEmail = emailFieldController.text;
    String userPassword = passwordFieldController.text;
  }

  // signup callback function
  void signUpCallback() {
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
      height: MediaQuery.of(context).size.height * 0.4,
      child: TabBarView(
        controller: authTabController,
        children: <Widget>[
          _loginWTabBarViewAuthTabW(context),
          _signUpWTabBarViewAuthTabW(context),
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
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(text: "Log In"),
          Tab(text: "Sign Up"),
        ]);
  }

  // holds the login widgets for the authTabW
  Widget _loginWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileHomeViewW.emailTxtField(
              context, true, emailFieldController, loginFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, true, passwordFieldController, loginFormAutoValidate),
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
  Widget _signUpWTabBarViewAuthTabW(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profileHomeViewW.userNameTextField(
              context, userNameFieldController, signUpFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.emailTxtField(
              context, false, emailFieldController, signUpFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          profileHomeViewW.passwordTxtField(
              context, false, passwordFieldController, signUpFormAutoValidate),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          profileHomeViewW.actionBtnW(context, false, textFieldValidator),
        ],
      ),
    );
  }
}
