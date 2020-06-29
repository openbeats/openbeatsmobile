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
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // gets the songs for the playlist
      getCollectionSongs(context, widget.playlistParameters["playlistId"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: playlistViewScaffoldKey,
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
              : _playlistViewColumn(data),
        );
      },
    );
  }

  // holds the column to hold the controls and listTiles for the songs
  Widget _playlistViewColumn(PlaylistViewData data) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 200.0),
      separatorBuilder: (context, index) => Divider(),
      physics: BouncingScrollPhysics(),
      itemCount: data.getCurrPlaylistSongs().length,
      itemBuilder: (BuildContext context, int index) =>
          _songListTile(context, index, data),
    );
  }

  // holds the listTile to show playlist songs
  Widget _songListTile(BuildContext context, int index, PlaylistViewData data) {
    return ListTile(
      leading:
          cachedNetworkImageW(data.getCurrPlaylistSongs()[index]["thumbnail"]),
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
      onTap: () {},
    );
  }
}
