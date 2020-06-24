import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import './functions.dart' as functions;

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // controllers for textfields
  TextEditingController _joinUserNameFieldController =
      new TextEditingController();
  TextEditingController _signInEmailFieldController =
      new TextEditingController();
  TextEditingController _signInPasswordFieldController =
      new TextEditingController();
  TextEditingController _joinEmailFieldController = new TextEditingController();
  TextEditingController _joinPasswordFieldController =
      new TextEditingController();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _joinFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: widgets.profileTabAppBar(),
        body: _profileTabBody(),
      ),
    );
  }

  // holds the body of profileTab
  Widget _profileTabBody() {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          _authenticationPanel(),
          Consumer<ScreenHeight>(
            builder: (context, _res, child) {
              return SizedBox(
                height: (_res.isOpen)
                    ? MediaQuery.of(context).size.height * 0.5
                    : 0.0,
              );
            },
          ),
        ],
      ),
    );
  }

  // holds the tabBar based view for the login and sign up widgets
  Widget _authenticationPanel() {
    return Container(
      // color: Colors.grey[900],
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(children: [_signInContainer(), _joinContainer()]),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                _actionButton(context, false),
              ],
            )
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widgets.joinWelcomeText(),
            SizedBox(
              height: 20.0,
            ),
            widgets.userNameTextField(_joinUserNameFieldController),
            widgets.emailAddressTextField(context, _joinEmailFieldController),
            widgets.passwordTextField(
                context, _joinPasswordFieldController, true),
            _actionButton(context, true)
          ],
        ),
      ),
    );
  }

  // holds the actionButton
  Widget _actionButton(BuildContext context, bool _isJoin) {
    return Container(
      alignment: Alignment.centerRight,
      child: RaisedButton(
        child: Text((_isJoin) ? "Join" : "Sign In"),
        color: GlobalThemes().getAppTheme().primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          if (_isJoin)
            functions.validateFields(
                _joinEmailFieldController,
                _joinPasswordFieldController,
                _joinUserNameFieldController,
                _joinFormKey,
                context,
                _isJoin);
          else
            functions.validateFields(
                _signInEmailFieldController,
                _signInPasswordFieldController,
                null,
                _signInFormKey,
                context,
                _isJoin);
        },
      ),
    );
  }
}
