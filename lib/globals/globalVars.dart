import 'package:obsmobile/imports.dart';

// controller for the SlidingUpPanel
PanelController _slidingUpPanelController = new PanelController();
// holds the openbeatsAPI endpoint
String _apiEndpoint = "https://staging-api.openbeats.live";
// holds the error message currently being shown by the snackbar (to prevent the annoying queuing)
String _currentSnackBarErrorMessage;

// used to get the SlidingUpPanel controller
PanelController getSlidingUpPanelController() => _slidingUpPanelController;
// used to get the openbeatsAPI endpoint
String getApiEndpoint() => _apiEndpoint;
// used to get the currScackBarErrorMessage 
String getCurrSnackBarErrorMsg() => _currentSnackBarErrorMessage;

// used to set the currentSnackBarErrorMessage
void setCurrSnackBarErrorMsg(String value) => _currentSnackBarErrorMessage = value;

