import 'package:openbeatsmobile/models/app/scaffoldKeys.dart';

import './screens/index.dart' as indexScreen;
import './imports.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationTheme>(
          create: (_) => ApplicationTheme(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScaffoldKeys(),
        )
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      radius: 5.0,
      backgroundColor: Colors.blue,
      textStyle: TextStyle(color: Colors.white),
      handleTouth: true,
      textPadding: EdgeInsets.all(10.0),
      child: MaterialApp(
        title: "OpenBeats",
        theme: Provider.of<ApplicationTheme>(context).getCurrentTheme(),
        home: AudioServiceWidget(
          child: indexScreen.IndexScreen(),
        ),
      ),
    );
  }
}
