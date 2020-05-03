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
Widget emailTxtField(BuildContext context, bool issignIn,
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
Widget passwordTxtField(BuildContext context, bool issignIn,
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
Widget actionBtnW(BuildContext context, bool issignIn, Function callbackFun) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.15),
    height: 48,
    child: RaisedButton(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: (issignIn) ? Text("Sign In") : Text("Join"),
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
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(),
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

// holds the greeting message for the signIn tab
Widget signInTabGreetingMessage() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      "hello!",
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 60.0,
          color: globalColors.textActiveClr),
    ),
  );
}

// hodls the greeting message subtitle for the signIn tab
Widget signInTabGreetingSubtitleMessage() {
  return Container(
    child: Text(
      "Sign In to your account",
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: globalColors.textActiveClr),
    ),
  );
}

// holds the greeitng messsage for the join tab
Widget joinTabGreetingMessage() {
  return Container(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Create\n",
        style: GoogleFonts.openSans(
            color: globalColors.textActiveClr,
            fontWeight: FontWeight.bold,
            fontSize: 60.0),
        children: [
          TextSpan(
            text: "your own",
            style: GoogleFonts.openSans(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.normal,
                fontSize: 16.0),
          ),
          TextSpan(
            text: " Open",
            style: GoogleFonts.roboto(
                color: globalColors.textActiveClr,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          TextSpan(
            text: "Beats",
            style: GoogleFonts.roboto(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          TextSpan(
            text: " account",
            style: GoogleFonts.openSans(
                color: globalColors.textDefaultClr,
                fontWeight: FontWeight.normal,
                fontSize: 16.0),
          ),
        ],
      ),
    ),
  );
}
