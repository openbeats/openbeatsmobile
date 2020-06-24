import 'package:obsmobile/imports.dart';

// holds the appBar for the profileTab
Widget profileTabAppBar() {
  return AppBar(
    title: Text("Profile"),
    bottom: TabBar(tabs: [
      Tab(
        child: Text("Sign In"),
      ),
      Tab(
        child: Text("Join"),
      )
    ]),
  );
}

// holds the welcome text for the signinPanel
Widget signInWelcomeText() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "hello!\n",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
              color: GlobalThemes().getAppTheme().primaryColor),
        ),
        TextSpan(
          text: "Sign In with your account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        TextSpan(
          text: " account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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