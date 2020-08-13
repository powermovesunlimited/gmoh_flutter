import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/home_location_result.dart';
import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/ui/pages/locator/alt_location_page.dart';
import 'package:gmoh_app/ui/pages/locator/current_user_location.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/ui/pages/trip_confirmation_map.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/permissions_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ActionSelectionView extends StatefulWidget {
  final HomeLocationResult homeLocationResult;

  ActionSelectionView(this.homeLocationResult);

  @override
  _ActionSelectionViewState createState() => _ActionSelectionViewState();
}

class _ActionSelectionViewState extends State<ActionSelectionView>
    implements PermissionDialogListener {
  Position userPosition;
  LatLng startLocation;
  UserLocationsBloc _locationBloc;
  var hasRequestedLocationPermission = false;
  final permissionsHelper = new PermissionsHelper();

  @override
  void initState() {
    super.initState();
    var locationDatabase = LocationDatabase();
    _locationBloc = UserLocationsBloc(LocationRepository(locationDatabase));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background1300.png"),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 72.0, right: 24.0, left: 24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor("#078B91"),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    child: Text(
                      'Where are you going?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 34.0, right: 24.0, left: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage("assets/images/homeIcon.png"),
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Text('Home',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                color: Colors.pinkAccent,
                textColor: Colors.white,
                elevation: 4,
                onPressed: () async {
                  attemptToRetrieveUserPosition("Home",
                      widget.homeLocationResult, _locationBloc, context);
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Somewhere Else',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400)),
                    Icon(Icons.chevron_right),
                  ],
                ),
                color: Colors.pinkAccent,
                textColor: Colors.white,
                elevation: 4,
                onPressed: () async {
                  attemptToRetrieveUserPosition("Somewhere Else",
                      widget.homeLocationResult, _locationBloc, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onPermissionDenied() {
    hasRequestedLocationPermission = true;
  }

  @override
  void onRequestPermission() {
    setState(() {
      permissionsHelper.requestLocationPermission();
      hasRequestedLocationPermission = true;
    });
  }

  void attemptToRetrieveUserPosition(
      String destination,
      HomeLocationResult homeLocationResult,
      UserLocationsBloc locationBloc,
      BuildContext context) async {
    var locationPermissionGranted =
        await permissionsHelper.isLocationPermissionGranted();

    if (!locationPermissionGranted && !hasRequestedLocationPermission) {
      requestLocationPermission(
          destination, homeLocationResult, locationBloc, context);
      return;
    } else if (locationPermissionGranted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userPosition = position;
      });
      useGPSLocationThenNavigateToNextPage(destination);
    }
  }

  void requestLocationPermission(
      String destination,
      HomeLocationResult homeLocationResult,
      UserLocationsBloc locationBloc,
      BuildContext context) async {
    switch (await permissionsHelper.requestLocationPermission()) {
      case PermissionStatus.denied:
        {
          setState(() {
            hasRequestedLocationPermission = false;
          });
          permissionsHelper.onLocationPermissionDenied(context).then((value) =>
              findUserLocationThenNavigateToNextPage(
                  destination, homeLocationResult, locationBloc, context));
        }
        break;
      case PermissionStatus.permanentlyDenied:
        {
          setState(() {
            hasRequestedLocationPermission = false;
          });
          permissionsHelper.onLocationPermissionPermanentlyDenied(context);
        }
        break;
      case PermissionStatus.granted:
        {
          setState(() {
            hasRequestedLocationPermission = true;
          });
          useGPSLocationThenNavigateToNextPage(destination);
        }
        break;
      case PermissionStatus.restricted:
        {
          setState(() {
            hasRequestedLocationPermission = false;
          });
          permissionsHelper.onLocationPermissionDenied(context).then((value) =>
              findUserLocationThenNavigateToNextPage(
                  destination, homeLocationResult, locationBloc, context));
        }
        break;
      case PermissionStatus.undetermined:
        {
          setState(() {
            hasRequestedLocationPermission = false;
          });
          permissionsHelper.onLocationPermissionDenied(context).then((value) =>
              findUserLocationThenNavigateToNextPage(
                  destination, homeLocationResult, locationBloc, context));
        }
    }
  }

  Future useGPSLocationThenNavigateToNextPage(String destination) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (destination == "Home") {
      if (widget.homeLocationResult is HomeLocationSet) {
        // take user to trip map page
        var homeAddress = _locationBloc.getHomeLocation() as Location;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripConfirmationMap(
                homeAddress.latitude, homeAddress.longitude),
          ),
        );
      } else if (widget.homeLocationResult is HomeLocationNotSet) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeLocatorPage(LatLng(position.latitude, position.longitude)),
          ),
        );
      }
    } else if (destination == "Somewhere Else") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlternateLocationPage(
              LatLng(position.latitude, position.longitude),
            ),
          ));
    }
  }

  Future findUserLocationThenNavigateToNextPage(
      String destination,
      HomeLocationResult homeLocationResult,
      UserLocationsBloc locationBloc,
      BuildContext context) async {
    print("destination in permission helper $destination");

    if (destination == "Home") {
      if (homeLocationResult is HomeLocationSet) {
        // take user to trip map page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentUserLocationPage("Trip Map"),
          ),
        );
      } else if (homeLocationResult is HomeLocationNotSet) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentUserLocationPage(destination),
          ),
        );
      }
    } else if (destination == "Somewhere Else") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrentUserLocationPage(destination),
        ),
      );
    }
  }
}
