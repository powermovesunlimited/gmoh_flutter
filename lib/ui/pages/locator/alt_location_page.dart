import 'package:gmoh_app/ui/pages/locator/locator_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlternateLocationPage extends LocatorPage {
  static const String routeName = "/altLocationPage";

  AlternateLocationPage(LatLng latLng) : super();

  @override
  LocatorPageState createState() => AlternateLocationState();
}

class AlternateLocationState extends LocatorPageState {

  AlternateLocationState() : super();

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
  void navigateToNextPage() {
    //navigate to trip map page
    if (userEnteredAddress().isNotEmpty) {
      var enteredAddress = userEnteredAddress();
      // navigate to trip map page
      //Navigator.pushNamed(context, 'alt_location_page');
    }
  }
}
