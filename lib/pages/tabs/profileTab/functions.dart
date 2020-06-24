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
    _formKey.currentState.save();
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
