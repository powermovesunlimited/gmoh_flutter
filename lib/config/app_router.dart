import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/locator/alt_location_page.dart';
import 'package:gmoh_app/ui/pages/locator/current_user_location.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/ui/pages/ride_party_page.dart';
import 'package:gmoh_app/ui/pages/trip_confirmation_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppRouter {
  static Router router = Router();
  static Handler _actionSelectionHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ActionSelectionPage());

  static Handler _ridePartyPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RidePartyPage());

  static void setupRouter() {
    router.define('action_selection', handler: _actionSelectionHandler);
    router.define('ride_party_page', handler: _ridePartyPageHandler);
  }
}
