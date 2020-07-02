import 'package:obsmobile/imports.dart';
import './functions.dart' as functions;

// holds the appBar for the profileTab
Widget profileTabAppBar() {
  return AppBar(
    title: Text("Profile"),
  );
}

// hold the keyboard appearence based extra padding
Widget optionalExtraPadding(BuildContext mainContext) {
  return Consumer<ScreenHeight>(
    builder: (context, _res, child) {
      return SizedBox(
        height: (_res.isOpen) ? MediaQuery.of(context).size.height * 0.3 : 0,
      );
    },
  );
}

// holds the signUp and signIn Panel switcher
Widget signUpSignInPanelSwitcher(BuildContext context) {
  // getting the values
  return Consumer<ProfileTabData>(
    builder: (context, data, child) {
      // getting data
      bool _showSignInPanel = data.getShowSignInPanel();
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: (_showSignInPanel)
                ? "Don't have an account?"
                : "Already have an account?",
            style: TextStyle(fontSize: 16.0),
          ),
          WidgetSpan(
            child: GestureDetector(
              child: Text(
                (_showSignInPanel) ? " Join" : " Sign In",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                (_showSignInPanel)
                    ? data.setShowSignInPanel(false)
                    : data.setShowSignInPanel(true);
              },
            ),
          )
        ]),
      );
    },
  );
}

// holds the welcome text for the signinPanel
Widget signInWelcomeText() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "hello!\n",
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
              color: GlobalThemes().getAppTheme().primaryColor),
        ),
        TextSpan(
          text: "Sign In with your account",
          style:
              GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ],
    ),
  );
}

// holds the welcome text for the joinPanel
Widget joinWelcomeText() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Join!\n",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
              color: GlobalThemes().getAppTheme().primaryColor),
        ),
        TextSpan(
          text: "To get your own",
          style:
              GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        TextSpan(
          text: " account",
          style:
              GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ],
    ),
  );
}

// holds the username field
Widget userNameTextField(TextEditingController _controller) {
  return Container(
    child: TextFormField(
      controller: _controller,
      cursorColor: GlobalThemes().getAppTheme().primaryColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        alignLabelWithHint: false,
        icon: Icon(Icons.person),
        hintText: "Profile Name",
      ),
      validator: (String arg) {
        if (arg.length < 3)
          return 'Please enter a longer profile name';
        else
          return null;
      },
    ),
  );
}

// holds the email address field
Widget emailAddressTextField(
    BuildContext context, TextEditingController _controller) {
  return Container(
    child: TextFormField(
      controller: _controller,
      cursorColor: GlobalThemes().getAppTheme().primaryColor,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        alignLabelWithHint: false,
        icon: Icon(Icons.email),
        hintText: "Email Address",
      ),
      validator: (String arg) {
        if (!arg.contains("@") || arg.length < 3)
          return 'Please enter valid email address';
        else
          return null;
      },
    ),
  );
}

// holds the password field
Widget passwordTextField(
    BuildContext context, TextEditingController _controller, bool _isJoin) {
  bool _showPassword = (_isJoin)
      ? Provider.of<ProfileTabData>(context).getShowPasswordJoin()
      : Provider.of<ProfileTabData>(context).getShowPasswordSignIn();
  return Container(
    child: TextFormField(
      controller: _controller,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            (!_showPassword) ? Icons.visibility_off : Icons.visibility,
          ),
          iconSize: 20.0,
          color: Colors.grey,
          onPressed: () => (_isJoin)
              ? Provider.of<ProfileTabData>(context, listen: false)
                  .setShowPasswordJoin()
              : Provider.of<ProfileTabData>(context, listen: false)
                  .setShowPasswordSignIn(),
        ),
        hintText: "Password",
      ),
      validator: (String arg) {
        if (arg.length < 6)
          return 'Please enter password longer\nthan 6 characters';
        else
          return null;
      },
    ),
  );
}

// holds the forgot password text button
Widget forgotPasswordButton() {
  return Container(
    child: GestureDetector(
      child: Text(" Forgot Password?"),
      onTap: () {},
    ),
  );
}

// holds the profileTabProfileView
Widget profileTabProfileView(BuildContext context) {
  return Consumer<UserModel>(
    builder: (context, data, child) {
      // removing null values
      String _avatar = data.getUserDetails()["avatar"];
      String _name = data.getUserDetails()["name"];
      if (_name == null) _name = "";
      return Container(
        // color: Colors.grey[900],
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _profileViewImage(_avatar),
            SizedBox(height: 20.0),
            _profileViewUserName(_name),
            SizedBox(height: 60.0),
          ],
        ),
      );
    },
  );
}

// holds the profile image view for the profile view
Widget _profileViewImage(String _imageUrl) {
  return Container(
    height: 80.0,
    width: 80.0,
    child: cachedNetworkImageW(_imageUrl),
  );
}

// holds the user name widget for the profile view
Widget _profileViewUserName(String _userName) {
  return Container(
    child: Text(
      _userName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      ),
    ),
  );
}

// // holds the row of user metadata for profile view
// Widget _profileViewMetadata() {
//   return Container(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         _templateMetaData(),
//         _templateMetaData(),
//         _templateMetaData()
//       ],
//     ),
//   );
// }

// // holds the template metadata option
// Widget _templateMetaData() {
//   return Container(
//     padding: EdgeInsets.all(20.0),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.white),
//       borderRadius: BorderRadius.circular(5.0),
//     ),
//     child: Column(
//       children: <Widget>[
//         Text("Name", style: TextStyle(fontSize: 14.0)),
//         Text("6000", style: TextStyle(fontSize: 20.0)),
//         Text("hours")
//       ],
//     ),
//   );
// }

// holds the settings title
Widget settingsTitle(BuildContext context) {
  return Container(
    child: ListTile(
      dense: true,
      title: Text(
        "Settings",
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

// holds the logout list tile
Widget logoutListTile(BuildContext context) {
  String _userName = Provider.of<UserModel>(context).getUserDetails()["name"];
  return AnimatedSwitcher(
    duration: Duration(milliseconds: 300),
    child: Container(
      child: (_userName != null)
          ? ListTile(
              leading: Icon(Icons.power_settings_new, color: Colors.red),
              title: Text("Sign Out",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
              onTap: () => functions.logoutUser(context),
            )
          : null,
    ),
  );
}
