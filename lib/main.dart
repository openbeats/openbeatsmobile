import 'package:openbeatsmobile/models/app/theme.dart';

import './screens/index.dart' as indexScreen;
import './imports.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      home: indexScreen.IndexScreen(),
    );
  }
}
