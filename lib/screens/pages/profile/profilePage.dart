import '../../../imports.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () async {
            Map<String, dynamic> _updateCheckResponse = await checkForUpdate();
            showUpdateDialog(_updateCheckResponse,context);
          },
          child: Text("Update App Now!"),
        ),
      ),
    );
  }
}
