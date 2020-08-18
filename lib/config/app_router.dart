import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/ride_party_page.dart';

class AppRouter {
  static Router router = Router();
  static RouteData route = RouteData();
  static Handler _actionSelectionHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ActionSelectionPage());

  static Handler _ridePartyPageHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RidePartyPage(route.origin, route.destination));

  static void setupRouter() {
    router.define('action_selection', handler: _actionSelectionHandler);
    router.define('ride_party_page', handler: _ridePartyPageHandler);
  }
}
