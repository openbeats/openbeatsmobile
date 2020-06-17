import 'package:obsmobile/imports.dart';
import 'package:obsmobile/pages/homePage/homePage.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomePageData>(create: (_) => HomePageData()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalThemes().getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: AudioServiceWidget(
        child: HomePage(),
      ),
    );
  }
}
