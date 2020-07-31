import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';

class HomeLocatorPage extends LocatorPage {
  static const String routeName = "/homeLocatorPage";
  final Position position;

  HomeLocatorPage(this.position) : super(position);

  @override
  LocatorPageState createState() => _HomeLocatorState(position);
}

class _HomeLocatorState extends LocatorPageState {
  _HomeLocatorState(Position position) : super(position);
  UserLocationsBloc _locationBloc;

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
    if (useEnteredAddress().isNotEmpty) {
      var homeAddress = useEnteredAddress();
      _locationBloc.setHomeLocation(
          homeAddress.first, homeAddress.elementAt(1), homeAddress.last);
        // navigate to trip map page
        //Navigator.pushNamed(context, 'alt_location_page');
    }
  }
}
