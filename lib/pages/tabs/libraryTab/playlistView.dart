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
    return Scaffold(
      appBar: widgets.appBarPlaylistView(
        widget.playlistParameters["playlistName"],
      ),
      body: _playlistViewBody(),
    );
  }

  // holds the playlist view body
  Widget _playlistViewBody() {
    return Consumer<PlaylistViewData>(
      builder: (context, data, child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: (data.getIsLoading())
              ? Center(
                  child: loadingAnimationW(),
                )
              : Container(),
        );
      },
    );
  }
}
