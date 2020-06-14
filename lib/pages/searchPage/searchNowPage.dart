import 'package:openbeatsmobile/imports.dart';

class SearchNowPage extends StatefulWidget {
  @override
  _SearchNowPageState createState() => _SearchNowPageState();
}

class _SearchNowPageState extends State<SearchNowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }

  // holds the appBar for the SearchNowPage
  Widget _appBar() {
    return AppBar(
      title: _appBarTextField(),
    );
  }

  // holds the textfield in the appBar
  Widget _appBarTextField() {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none),
    );
  }
}
