import 'package:obsmobile/imports.dart';
import './widgets.dart' as widgets;
import './functions.dart' as functions;

class PlaylistView extends StatefulWidget {
  // holds the passed playlistParameters
  Map<String, dynamic> playlistParameters;
  PlaylistView(this.playlistParameters);
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.playlistParameters["isCollection"])
        // gets the songs for the playlist
        getCollectionSongs(
            context, widget.playlistParameters["arguments"]["playlistId"]);
      else {
        // getting user token
        String _userToken = Provider.of<UserModel>(context, listen: false)
            .getUserDetails()["token"];
        getPlaylistSongs(context,
            widget.playlistParameters["arguments"]["playlistId"], _userToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: playlistViewScaffoldKey,
      appBar: widgets.appBarPlaylistView(
        widget.playlistParameters["arguments"]["playlistName"],
      ),
      body: _playlistViewBody(),
    );
  }

  // holds the playlist view body
  Widget _playlistViewBody() {
    return Consumer<PlaylistViewData>(
      builder: (context, data, child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: (data.getIsLoading())
              ? Center(
                  child: loadingAnimationW(),
                )
              : _playlistViewColumn(data),
        );
      },
    );
  }

  // holds the column to hold the controls and listTiles for the songs
  Widget _playlistViewColumn(PlaylistViewData data) {
    return StreamBuilder(
      stream: AudioService.currentMediaItemStream,
      builder: (context, snapshot) {
        MediaItem _currMediaItem = snapshot.data;
        return ListView.separated(
          padding: EdgeInsets.only(bottom: 200.0),
          separatorBuilder: (context, index) => Divider(),
          physics: BouncingScrollPhysics(),
          itemCount: data.getCurrPlaylistSongs().length,
          itemBuilder: (BuildContext context, int index) =>
              _songListTile(context, index, data, _currMediaItem),
        );
      },
    );
  }

  // holds the listTile to show playlist songs
  Widget _songListTile(BuildContext context, int index, PlaylistViewData data,
      MediaItem _currMediaItem) {
    // check if this song is the current playing song
    bool _isPlaying = (_currMediaItem != null &&
        _currMediaItem.extras["vidId"] ==
            data.getCurrPlaylistSongs()[index]["_id"] &&
        _currMediaItem.extras["playlist"] == "true");
    return ListTile(
      selected: _isPlaying,
      leading: cachedNetworkImageW(
        data.getCurrPlaylistSongs()[index]["thumbnail"],
      ),
      title: Text(
        data.getCurrPlaylistSongs()[index]["title"],
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.0),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Text(data.getCurrPlaylistSongs()[index]["duration"] +
            " • " +
            reformatViewstoHumanReadable(
                data.getCurrPlaylistSongs()[index]["views"])),
      ),
      trailing: GestureDetector(
        child: Icon(Icons.more_vert),
        onTap: () {},
      ),
      onTap: () => (_isPlaying)
          ? getSlidingUpPanelController().open()
          : functions.initiatePlaylistPlayback(context, index),
    );
  }
}
