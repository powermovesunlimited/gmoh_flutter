import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentUserLocationPage extends LocatorPage {
  static const String routeName = "/currentUserLocationPage";

  CurrentUserLocationPage(String destination) : super();

  @override
  LocatorPageState createState() => _CurrentUserLocationState();
}

class _CurrentUserLocationState extends LocatorPageState {
  _CurrentUserLocationState() : super();

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
  void navigateToNextPage() {
    //navigate back to action selection page
    if (userEnteredAddress().isNotEmpty) {
      var latitude = userEnteredAddress().elementAt(1);
      var longitude = userEnteredAddress().last;
      var startLocation = LatLng(latitude, longitude);
      Navigator.pop(context, '$startLocation');
    }
  }
}
