import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';

class AlternateLocationPage extends LocatorPage {
  static const String routeName = "/altLocationPage";

  AlternateLocationPage();

  @override
  LocatorPageState createState() => AlternateLocationState();
}

class AlternateLocationState extends LocatorPageState {
  AlternateLocationState() : super();

  @override
  String getHintText() {
    return "Enter your destination address here...";
  }

  @override
  String getAppBarTitle() {
    return "Where are you going ?";
  }

  @override
  String getContinueButtonText() {
    return "Set Address and Go";
  }
}
