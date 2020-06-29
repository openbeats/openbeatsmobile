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

// reformats timestamp into seconds
int reformatTimeStampToMilliSeconds(String timeStamp) {
  // holds the seconds in integer format
  int totalSeconds = 0;
  // converting timeStamp into list of digits in integer format
  List<int> timeStampLst = timeStamp
      .split(":")
      .map((digitString) => int.parse(digitString))
      .toList();
  if (timeStampLst.length == 2) {
    // adding minutes and seconds to total seconds
    totalSeconds += (timeStampLst[0] * 60000) + (timeStampLst[1] * 1000);
  } else if (timeStampLst.length == 3) {
    // adding hours and minutes and seconds to total seconds
    totalSeconds += (timeStampLst[0] * 3600 * 1000) +
        (timeStampLst[1] * 60) +
        timeStampLst[2];
  }
  // return the total seconds
  return (totalSeconds);
}

// return the current duration string in min:sec
String getCurrentTimeStamp(double totalSeconds) {
  if (totalSeconds != null) {
    // variables holding separated time
    String min, sec, hour;
    // holds the total seconds to help decide if I need to send hours or not at the end
    double totalSecondsPlaceHolder = totalSeconds;
    // check if it is greater than one hour
    if (totalSeconds > 3600) {
      // getting number of hours
      hour = ((totalSeconds % (24 * 3600)) / 3600).floor().toString();
      totalSeconds %= 3600;
    }
    // getting number of minutes
    min = (totalSeconds / 60).floor().toString();
    totalSeconds %= 60;
    // getting number of seconds
    sec = (totalSeconds).floor().toString();
    // adding the necessary zeros
    if (int.parse(sec) < 10) sec = "0" + sec;
    // if the duration is greater than 1 hour, return with hour
    if (totalSecondsPlaceHolder > 3600) {
      if (double.parse(min) < 10.0) {
        return (hour.toString() + ":0" + min.toString() + ":" + sec.toString());
      } else {
        return (hour.toString() + ":" + min.toString() + ":" + sec.toString());
      }
    } else {
      if (double.parse(min) < 10.0) {
        return ("0" + min.toString() + ":" + sec.toString());
      } else {
        return (min.toString() + ":" + sec.toString());
      }
    }
  } else
    return "00:00";
}

// used to show snackBar
void showFlushBar(BuildContext context, Map<String, dynamic> parameters) {
  Flushbar(
    title: parameters["title"],
    flushbarPosition: FlushbarPosition.TOP,
    forwardAnimationCurve: Curves.ease,
    reverseAnimationCurve: Curves.ease,
    message: parameters["message"],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    borderRadius: 5,
    routeBlur: 5.0,
    blockBackgroundInteraction: parameters["blocking"],
    backgroundColor: parameters["color"],
    isDismissible: true,
    icon: parameters["icon"],
    duration: parameters["duration"],
    shouldIconPulse: true,
  ).show(context);
}
