import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class HomeLocatorPage extends LocatorPage {
  static const String routeName = "/homeLocatorPage";

  HomeLocatorPage(LatLng latLng) : super();

  @override
  LocatorPageState createState() => _HomeLocatorState();
}

class _HomeLocatorState extends LocatorPageState {

  var currentUserLocation;
  TextEditingController textEditingController = new TextEditingController();

  _HomeLocatorState() : super();
  UserLocationsBloc _locationBloc;

  @override
  void initState() {
    super.initState();
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
  void navigateToNextPage() {
    // save address as home
//    if (userEnteredAddress().isNotEmpty) {
//      var homeAddress = userEnteredAddress();
//      _locationBloc.setHomeLocation(
//          homeAddress.first, homeAddress.elementAt(1), homeAddress.last);
//      // navigate to trip map page
//      //Navigator.pushNamed(context, 'alt_location_page');
//    }
  }
}
