import 'package:obsmobile/imports.dart';
import 'package:obsmobile/pages/homePage/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalThemes().getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
