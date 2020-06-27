import 'package:obsmobile/imports.dart';
import './functions.dart' as functions;
import './widgets.dart' as widgets;

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  // controllers for textfields
  static TextEditingController _joinUserNameFieldController =
      new TextEditingController();
  static TextEditingController _signInEmailFieldController =
      new TextEditingController();
  static TextEditingController _signInPasswordFieldController =
      new TextEditingController();
  static TextEditingController _joinEmailFieldController =
      new TextEditingController();
  static TextEditingController _joinPasswordFieldController =
      new TextEditingController();

  // form keys for auth panels
  static GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  static GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();

  // holds the tab controller for the authpanel
  TabController _authTabController;

  @override
  void initState() {
    super.initState();
    // initiating tab controller
    _authTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: profileTabScaffoldKey,
      appBar: widgets.profileTabAppBar(),
      body: _profileTabBody(),
    );
  }

  // holds the body of the profile body
  Widget _profileTabBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[_profileTabHeader(), _appSettings()],
    );
  }

  // holds the profileTab header content
  Widget _profileTabHeader() {
    return Consumer<UserModel>(
      builder: (context, data, child) => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: (data.getUserDetails()["name"] == null)
            ? _profileTabAuthView(context, _authTabController)
            : widgets.profileTabProfileView(context),
      ),
    );
  }

  // holds the profileTabViewAuthView
  Widget _profileTabAuthView(
      BuildContext context, TabController _tabController) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        widgets.profileTabTabs(_tabController),
        _authPanelTabViews(context, _tabController),
      ],
    );
  }

  // holds the tabviews for the authentication panel
  Widget _authPanelTabViews(
      BuildContext context, TabController _tabController) {
    return Container(
      // color: Colors.grey[900],
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: _tabController,
        children: [
          _signInContainer(),
          _joinContainer(),
        ],
      ),
    );
  }

  // holds the widgets for the signInPanel
  Widget _signInContainer() {
    return Form(
      key: _signInFormKey,
      autovalidate:
          Provider.of<ProfileTabData>(context).getAutoValidateSignIn(),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            widgets.signInWelcomeText(),
            SizedBox(
              height: 30.0,
            ),
            widgets.emailAddressTextField(context, _signInEmailFieldController),
            widgets.passwordTextField(
                context, _signInPasswordFieldController, false),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widgets.forgotPasswordButton(),
                _actionButton(false),
              ],
            ),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.landscape)
                      ? 150.0
                      : 0.0,
            ),
            widgets.optionalExtraPadding(context)
          ],
        ),
      ),
    );
  }

// holds the widgets for the joinPanel
  Widget _joinContainer() {
    return Form(
      key: _joinFormKey,
      autovalidate: Provider.of<ProfileTabData>(context).getAutoValidateJoin(),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            widgets.joinWelcomeText(),
            SizedBox(
              height: 20.0,
            ),
            widgets.userNameTextField(_joinUserNameFieldController),
            widgets.emailAddressTextField(context, _joinEmailFieldController),
            widgets.passwordTextField(
                context, _joinPasswordFieldController, true),
            _actionButton(true),
            SizedBox(
              height:
                  (MediaQuery.of(context).orientation == Orientation.landscape)
                      ? 150.0
                      : 0.0,
            ),
            widgets.optionalExtraPadding(context)
          ],
        ),
      ),
    );
  }

  // holds the actionButton
  Widget _actionButton(bool _isJoin) {
    return Container(
      alignment: Alignment.centerRight,
      child: Consumer<ProfileTabData>(
        builder: (context, data, child) => RaisedButton(
          child: (data.getIsLoading())
              ? Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  height: 20.0,
                  width: 20.0,
                )
              : Text((_isJoin) ? "Join" : "Sign In"),
          color: GlobalThemes().getAppTheme().primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () async {
            // setting isLoading flag
            data.setIsLoading(true);
            Map<String, dynamic> _authResponse;
            if (_isJoin) {
              _authResponse = await functions.validateFields(context, {
                "_emailFieldController": _joinEmailFieldController,
                "_passwordFieldController": _joinPasswordFieldController,
                "_userNameFieldController": _joinUserNameFieldController,
                "_formKey": _joinFormKey,
                "_isJoin": _isJoin
              });
            } else {
              _authResponse = await functions.validateFields(context, {
                "_emailFieldController": _signInEmailFieldController,
                "_passwordFieldController": _signInPasswordFieldController,
                "_userNameFieldController": null,
                "_formKey": _signInFormKey,
                "_isJoin": _isJoin
              });
            }
            // resetting the loading flag
            data.setIsLoading(false);
            if (_authResponse["status"] == false) {
              if (_authResponse["message"] == "InvalidCredentials") {
                showFlushBar(
                  context,
                  {
                    "message": "Please check your email address and password",
                    "color": Colors.deepOrange,
                    "duration": Duration(seconds: 3),
                    "title": "Invalid Credentials",
                    "blocking": true,
                    "icon": Icons.warning,
                  },
                );
              } else {
                showFlushBar(
                  context,
                  {
                    "message": _authResponse["message"],
                    "color": Colors.deepOrange,
                    "duration": Duration(seconds: 3),
                    "title": "An error occurred",
                    "blocking": true,
                    "icon": Icons.warning,
                  },
                );
              }
            } else {
              // clearing all textfields
              _signInEmailFieldController.clear();
              _signInPasswordFieldController.clear();
              _joinEmailFieldController.clear();
              _joinPasswordFieldController.clear();
              _joinUserNameFieldController.clear();

              // showing welcome message
              if (_isJoin) {
                showFlushBar(
                  context,
                  {
                    "message": "We sure hope you enjoy our little project! 😃",
                    "color": Colors.green,
                    "duration": Duration(seconds: 5),
                    "title": "Welcome to Openbeats",
                    "blocking": false,
                    "icon": Icons.check,
                  },
                );
              } else {
                showFlushBar(
                  context,
                  {
                    "message": "Great to see you again! 😊",
                    "color": Colors.green,
                    "duration": Duration(seconds: 3),
                    "title": "Welcome back!",
                    "blocking": false,
                    "icon": Icons.check,
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  // holds the application settings listTiles
  Widget _appSettings() {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          widgets.logoutListTile(context),
        ],
      ),
    );
  }
}
