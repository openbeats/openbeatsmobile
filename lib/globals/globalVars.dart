import 'package:obsmobile/imports.dart';

// controller for the SlidingUpPanel
PanelController _slidingUpPanelController = new PanelController();

// holds the openbeatsAPI endpoint
String _apiEndpoint = "https://staging-api.openbeats.live";

// used to get the SlidingUpPanel controller
PanelController getSlidingUpPanelController() => _slidingUpPanelController;
// used to get the openbeatsAPI endpoint
String getApiEndpoint() => _apiEndpoint;
