import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;

class PlaylistView extends StatefulWidget {
  // holds the passed playlistParameters
  Map<String, String> playlistParameters;
  PlaylistView(this.playlistParameters);
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    print(widget.playlistParameters);
    return Scaffold(
      appBar: widgets.appBarPlaylistView("Sample Title"),
    );
  }
}
