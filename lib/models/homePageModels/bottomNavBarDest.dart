import 'package:obsmobile/imports.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Explore', Icons.explore, Colors.teal),
  Destination('Search', Icons.search, Colors.indigo),
  Destination('Library', Icons.library_music, Colors.orange),
  Destination('Profile', Icons.person, Colors.blue)
];
