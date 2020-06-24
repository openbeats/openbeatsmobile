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
    ),
  );
}

// holds the password field
Widget passwordTextField(
    BuildContext context, TextEditingController _controller) {
  bool _showPassword = Provider.of<ProfileTabData>(context).getShowPassword();
  return Container(
    child: TextFormField(
      controller: _controller,
      obscureText: Provider.of<ProfileTabData>(context).getShowPassword(),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            (_showPassword) ? Icons.visibility_off : Icons.visibility,
          ),
          iconSize: 20.0,
          color: Colors.grey,
          onPressed: () => Provider.of<ProfileTabData>(context, listen: false)
              .setShowPassword(),
        ),
        hintText: "Password",
      ),
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

// holds the actionButton
Widget actionButton(BuildContext context) {
  return Container(
    child: RaisedButton(
      child: Text("Sign In"),
      color: GlobalThemes().getAppTheme().primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: () {},
    ),
  );
}
