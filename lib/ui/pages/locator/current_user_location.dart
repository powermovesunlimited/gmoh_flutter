import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentUserLocationPage extends LocatorPage {
  static const String routeName = "/currentUserLocationPage";
  CurrentUserLocationPage(RouteData routeData, RouteIntent routeIntent) : super(routeData, routeIntent);

  @override
  LocatorPageState createState() => _CurrentUserLocationState(this.routeData);
}

class _CurrentUserLocationState extends LocatorPageState {
  final RouteData routeData;
  _CurrentUserLocationState(this.routeData) : super(routeData);

  @override
  String getHintText() {
    return "Enter your current location's address";
  }

  @override
  String getAppBarTitle() {
    return "What is Your Current Location?";
  }

  @override
  String getContinueButtonText() {
    return "Set as Current Location";
  }

  @override
  onAddressSelected(String address, LatLng location) {
  }
}
