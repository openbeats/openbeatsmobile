// package imports
export 'package:flutter/material.dart';
export 'package:flutter/foundation.dart';
export 'package:provider/provider.dart';
export 'package:flutter/services.dart';
export 'package:sliding_up_panel/sliding_up_panel.dart';
export 'dart:async';
export 'package:audio_service/audio_service.dart';
import 'package:audio_service/audio_service.dart';
export 'package:just_audio/just_audio.dart';
export 'package:ota_update/ota_update.dart';
export 'package:http/http.dart';
export 'dart:convert';
export 'package:package_info/package_info.dart';
export 'package:oktoast/oktoast.dart';
export 'package:ext_storage/ext_storage.dart';
export 'dart:io';
export 'package:shared_preferences/shared_preferences.dart';

// file imports
export 'package:openbeatsmobile/pages/homePage.dart';
export 'package:openbeatsmobile/components/themeComponents/themeComponents.dart';
export 'package:openbeatsmobile/services/streamingService/streamingService.dart';
export 'package:openbeatsmobile/functions/appFunctions/debugFunctions.dart';
export 'package:openbeatsmobile/components/bottomNavBarDestinations/bottomNavBarDestinations.dart';
export 'package:openbeatsmobile/models/homePageModels/homePageModel.dart';
export 'package:openbeatsmobile/components/scaffoldKeys/scaffoldKeysComponent.dart';
export 'package:openbeatsmobile/pages/explorePage/explorePage.dart';
export 'package:openbeatsmobile/pages/searchPage/searchPage.dart';
export 'package:openbeatsmobile/pages/libraryPage/libraryPage.dart';
export 'package:openbeatsmobile/pages/profilePage/profilePage.dart';
export 'package:openbeatsmobile/models/AppState/appState.dart';
export 'package:openbeatsmobile/functions/homePage/homePageFunctions.dart';
export 'package:openbeatsmobile/pages/searchPage/searchNowPage.dart';
export 'package:openbeatsmobile/services/sharedPrefsService/searchPage/searchPageSPrefs.dart';
export 'package:openbeatsmobile/components/appComponents/appComponents.dart';
export 'package:openbeatsmobile/models/SearchPageModels/searchPageModel.dart';
export 'package:openbeatsmobile/services/httpService/searchPage/searchPageHttpService.dart';
export 'package:openbeatsmobile/models/SearchPageModels/searchNowPageModel.dart';

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
