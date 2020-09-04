import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlternateLocationPage extends LocatorPage {
  static const String routeName = "/altLocationPage";

  AlternateLocationPage(RouteData route, RouteIntent intent) : super(route, intent);

  @override
  LocatorPageState createState() => AlternateLocationState(this.routeData);
}

class AlternateLocationState extends LocatorPageState {
  final RouteData routeData;

  AlternateLocationState(this.routeData) : super(routeData);

  @override
  void initState() {
    super.initState();
  }

  @override
  String getHintText() {
    return "Enter your destination address here";
  }

  @override
  String getAppBarTitle() {
    return "Where are you going ?";
  }

  @override
  String getContinueButtonText() {
    return "Set Address and Go";
  }

  @override
  onAddressSelected(String address, LatLng location) {
  }
}
