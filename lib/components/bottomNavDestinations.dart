import '../imports.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Explore', Icons.explore, Colors.lightGreen),
  Destination('Search', Icons.search, Colors.cyan),
  Destination('Library', Icons.library_music, Colors.orange),
  Destination('Profile', Icons.person, Colors.blue)
];
