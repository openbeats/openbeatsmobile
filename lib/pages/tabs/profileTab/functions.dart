// holds the validator for sign in
import 'package:obsmobile/imports.dart';

void validateFields(
    TextEditingController _emailController,
    TextEditingController _passwordController,
    TextEditingController _userNameController,
    GlobalKey<FormState> _formKey,
    BuildContext context,
    bool _isJoin) {
  if (_formKey.currentState.validate()) {
    if (_isJoin) {
      // getting values

    } else {
      // getting values
      String _emailAddress = _emailController.text.trim();
      String _password = _passwordController.text;

    
    }
  } else {
    if (_isJoin) {
      Provider.of<ProfileTabData>(context, listen: false)
          .setAutoValidateJoin(true);
    } else {
      Provider.of<ProfileTabData>(context, listen: false)
          .setAutoValidateSignIn(true);
    }
  }
}
