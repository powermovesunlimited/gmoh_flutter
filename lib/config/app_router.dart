import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/locator/alt_location_page.dart';
import 'package:gmoh_app/ui/pages/locator/current_user_location.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/ui/pages/ride_party_page.dart';
import 'package:gmoh_app/ui/pages/trip_confirmation_map.dart';

class AppRouter {
  static Router router = Router();
  static Handler _actionSelectionHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ActionSelectionPage());

  static Handler _ridePartyPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RidePartyPage());

  static Handler _alternateLocationPageHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        var position = (params['position']);
        return AlternateLocationPage(position);
  });

  static Handler _homeLocatorPageHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        var position = (params['position']);
        return HomeLocatorPage(position);
  });

  static Handler _mapPageHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    final String latitude = (params['latlng'][0]).toString().split(",")[0];
    final String longitude = (params['latlng'][0]).toString().split(",")[1];
    return TripConfirmationMap(double.parse(latitude), double.parse(longitude));
  });

  static Handler _currentUserLocationPageHandler =
  Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    var position = (params['position']);
    return CurrentUserLocationPage(position);
  });

  static void setupRouter() {
    router.define('action_selection', handler: _actionSelectionHandler);
    router.define('ride_party_page', handler: _ridePartyPageHandler);
    router.define('alt_location_page/:userPosition', handler: _alternateLocationPageHandler);
    router.define('home_locator_page/:userPosition', handler: _homeLocatorPageHandler);
    router.define('map/:latlng', handler: _mapPageHandler);
    router.define('current_user_location', handler: _currentUserLocationPageHandler);
  }
}
