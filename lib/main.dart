import './imports.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OpenBeats",
      theme: ThemeComponents().themeData,
      home: AudioServiceWidget(
        child: HomePage(),
      ),
    );
  }
}
