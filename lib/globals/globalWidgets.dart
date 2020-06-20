import 'package:obsmobile/imports.dart';

// holds the loading animation for the application
Widget loadingAnimationW() {
  return Container(
    height: 100.0,
    child: FlareActor(
      "assets/flareAssets/loadinganim.flr",
      animation: "loadnew",
    ),
  );
}

// holds the cachedNetworkImage for the entire application
Widget cachedNetworkImageW(String imgUrl) {
  return (imgUrl != null)
      ? Container(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        )
      : Image.asset(
          "assets/images/supplementary/dummyimage.png",
          fit: BoxFit.cover,
        );
}
