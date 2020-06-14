import 'package:openbeatsmobile/imports.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _profilePageAppBar(),
    );
  }

  Widget _profilePageAppBar() {
    // getting the appBar theme
    AppBarTheme appBarTheme = ThemeComponents().getAppTheme().appBarTheme;
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          color: allDestinations[3].color,
          fontSize: appBarTheme.textTheme.headline6.fontSize,
          fontWeight: appBarTheme.textTheme.headline6.fontWeight,
        ),
      ),
      
    );
  }
}
