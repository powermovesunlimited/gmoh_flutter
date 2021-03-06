import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeLocatorPage extends LocatorPage {
  static const String routeName = "/homeLocatorPage";

  HomeLocatorPage(RouteData route, RouteIntent intent) : super(route, intent);

  @override
  LocatorPageState createState() => _HomeLocatorState(this.routeData);
}

class _HomeLocatorState extends LocatorPageState {
  final RouteData routeData;

  var currentUserLocation;
  TextEditingController textEditingController = new TextEditingController();

  _HomeLocatorState(this.routeData) : super(routeData);
  UserLocationsBloc _locationBloc;

  @override
  void initState() {
    super.initState();
    LocationDatabase database = LocationDatabase();
    LocationRepository repository= LocationRepository(database);
    _locationBloc = UserLocationsBloc(repository);
  }

  saveHomeAddress(String address, LatLng location){
    if (address.isNotEmpty && location != null) {
      _locationBloc.setHomeLocation(address, location.latitude, location.longitude);
    }
  }

  @override
  String getHintText() {
    return "Enter your home address here";
  }

  @override
  String getAppBarTitle() {
    return "Where's Home?";
  }

  @override
  String getContinueButtonText() {
    return "Set as Home and Go";
  }

  @override
  onAddressSelected(String address, LatLng location) {
    saveHomeAddress(address, location);
  }
}
