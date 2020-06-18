import 'package:obsmobile/imports.dart';

// reformats the views count to plays in the B,M,K format
String reformatViewstoHumanReadable(String views) {
  // string to return the final count
  String plays = "";
  // removing the trailing text, and commas
  views = views.replaceFirst(" views", "").replaceAll(",", "");
  // formating number based on its string length
  if (views.length > 10) {
    plays = views[0] + views[1] + "B plays";
  } else if (views.length > 9) {
    plays = views[0] + "B plays";
  } else if (views.length > 8) {
    plays = views[0] + views[1] + views[2] + "M plays";
  } else if (views.length > 7) {
    plays = views[0] + views[1] + "M plays";
  } else if (views.length > 6) {
    plays = views[0] + "M plays";
  } else if (views.length > 5) {
    plays = views[0] + views[1] + views[2] + "K plays";
  } else if (views.length > 4) {
    plays = views[0] + views[1] + "K plays";
  } else if (views.length > 3) {
    plays = views[0] + "K plays";
  } else {
    plays = views + " plays";
  }

  return plays;
}