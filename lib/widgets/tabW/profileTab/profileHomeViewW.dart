import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../globals/globalColors.dart' as globalColors;

// holds the AppBar for the profileHomeView
Widget appBar() {
  return AppBar(
    title: Text("Profile"),
  );
}

// holds the email textfield for the tabView
Widget emailTxtField(BuildContext context, bool isLogin,
    TextEditingController controller, bool autoValidate) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      autovalidate: autoValidate,
      cursorColor: globalColors.iconActiveClr,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.email),
        hintText: "Email Address",
      ),
      validator: (String value) {
        if (value.length == 0 || !value.contains("@"))
          return 'Please enter valid email address';
        else
          return null;
      },
    ),
  );
}

// holds the password textfield for the tabView
Widget passwordTxtField(BuildContext context, bool isLogin,
    TextEditingController controller, bool autoValidate) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      autovalidate: autoValidate,
      cursorColor: globalColors.iconActiveClr,
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.lock),
        hintText: "Password",
      ),
      validator: (String value) {
        if (value.length == 0)
          return 'Please enter valid password';
        else
          return null;
      },
    ),
  );
}

// holds the action button for the tabview
Widget actionBtnW(BuildContext context, bool isLogin, Function callbackFun) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: 48,
    child: RaisedButton(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: (isLogin) ? Text("Login") : Text("Sign Up"),
      color: globalColors.mainBtnClr,
      onPressed: callbackFun,
    ),
  );
}

// holds the forgot password button
Widget fgtPasswordBtn(BuildContext context) {
  return GestureDetector(
    child: Text(
      "Forgot Password?",
      style: GoogleFonts.poppins(),
    ),
    onTap: () {},
  );
}

// holds the username textfield for the tabview
Widget userNameTextField(
    BuildContext context, TextEditingController controller, bool autoValidate) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    child: TextFormField(
      controller: controller,
      autovalidate: autoValidate,
      cursorColor: globalColors.iconActiveClr,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.person),
        hintText: "User Name",
      ),
      validator: (String value) {
        if (value.length == 0)
          return 'Please enter your name';
        else
          return null;
      },
    ),
  );
}
