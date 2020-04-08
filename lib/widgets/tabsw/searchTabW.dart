import 'package:flutter/material.dart';
import '../../globals/globalColors.dart' as globalColors;

// holds the widget to show when the search results are loading
Widget searchResultLoadingW() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            globalColors.searchTabLoadingIndicatorColor,
          ),
        ),
      )
    ],
  );
}
