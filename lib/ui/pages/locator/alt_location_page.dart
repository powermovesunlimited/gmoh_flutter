import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';

class AlternateLocationPage extends LocatorPage {
  static const String routeName = "/altLocationPage";
  final Position position;

  AlternateLocationPage(this.position) : super(position);

  @override
  LocatorPageState createState() => AlternateLocationState(position);
}

class AlternateLocationState extends LocatorPageState {
  AlternateLocationState(position) : super(position);

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
  void navigateToNextPage() {
    //navigate to trip map page
    if (useEnteredAddress().isNotEmpty) {
      var enteredAddress = useEnteredAddress();
      // navigate to trip map page
      //Navigator.pushNamed(context, 'alt_location_page');
    }
  }
}
