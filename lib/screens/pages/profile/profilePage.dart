import '../../../imports.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _profilePageAppBar(),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            Map<String, dynamic> _updateCheckResponse = await checkForUpdate();
            showUpdateDialog(_updateCheckResponse, context);
          },
          child: Text("Update App Now!"),
        ),
      ),
    );
  }

  Widget _profilePageAppBar() {
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          color: Colors.blue,
          fontSize: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontSize,
          fontWeight: Provider.of<ApplicationTheme>(context)
              .getAppBarTextTheme()
              .headline6
              .fontWeight,
        ),
      ),
    );
  }
}
