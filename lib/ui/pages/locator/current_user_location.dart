import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';

class CurrentUserLocationPage extends LocatorPage {
  static const String routeName = "/currentUserLocationPage";
  final Position position;

  CurrentUserLocationPage(this.position) : super(position);

  @override
  LocatorPageState createState() => _CurrentUserLocationState(position);
}

class _CurrentUserLocationState extends LocatorPageState {
  _CurrentUserLocationState(position) : super(position);

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
    if (useEnteredAddress().isNotEmpty) {
      var enteredAddress = useEnteredAddress();
      Navigator.pop(context, 'action_selection/$enteredAddress');
    }
  }
}
