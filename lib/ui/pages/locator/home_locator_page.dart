import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/locator/locator_page.dart';

class HomeLocatorPage extends LocatorPage {
  static const String routeName = "/homeLocatorPage";

  HomeLocatorPage();

  @override
  LocatorPageState createState() => _HomeLocatorState();
}

class _HomeLocatorState extends LocatorPageState {
  _HomeLocatorState() : super();

  @override
  String getHintText() {
    return "Enter your home address here...";
  }

  @override
  String getAppBarTitle() {
    return "Where's Home?";
  }

  @override
  String getContinueButtonText() {
    return "Set as Home and Go";
  }
}
