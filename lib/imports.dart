// package imports
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:provider/provider.dart';
export 'package:flutter/services.dart';
export 'package:sliding_up_panel/sliding_up_panel.dart';
export 'dart:async';
export 'package:audio_service/audio_service.dart';
export 'package:just_audio/just_audio.dart';
export 'package:ota_update/ota_update.dart';
export 'package:http/http.dart';
export 'dart:convert';
export 'package:package_info/package_info.dart';
export 'package:oktoast/oktoast.dart';
export 'dart:io';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
export 'dart:math';
export 'package:flare_flutter/flare_actor.dart';
export 'package:flutter/services.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter/scheduler.dart';
export 'package:move_to_background/move_to_background.dart';
export 'package:flushbar/flushbar.dart';
export 'package:flushbar/flushbar_helper.dart';

// global dart file imports
export 'package:obsmobile/globals/globalFuncs.dart';
export 'package:obsmobile/globals/globalThemes.dart';
export 'package:obsmobile/globals/globalVars.dart';
export 'package:obsmobile/globals/globalWidgets.dart';
export 'package:obsmobile/globals/globalScaffoldKeys.dart';
export 'package:obsmobile/services/audioServiceOps.dart';
export 'package:obsmobile/services/networkOps.dart';
export 'package:obsmobile/services/sharedprefOps.dart';

// file imports
export 'package:obsmobile/pages/tabs/exploreTab/exploreTab.dart';
export 'package:obsmobile/pages/tabs/libraryTab/libraryTab.dart';
export 'package:obsmobile/pages/tabs/profileTab/profileTab.dart';
export 'package:obsmobile/pages/tabs/searchTab/searchTab.dart';
export 'package:obsmobile/models/homePageModels/bottomNavBarDest.dart';
export 'package:obsmobile/pages/tabs/searchTab/searchNowPage.dart';

// data model imports
export 'package:obsmobile/models/homePageModels/homePageData.dart';
export 'package:obsmobile/models/searchTabModels/searchTabModels.dart';
export 'package:obsmobile/models/profileTabModels/profileTabData.dart';
export 'package:obsmobile/models/appModels/userModel.dart';
export 'package:obsmobile/models/libraryTabModels/libraryTabData.dart';

// audio service exports
import 'package:audio_service/audio_service.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);
