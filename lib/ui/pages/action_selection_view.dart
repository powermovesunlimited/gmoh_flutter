import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/home_location_result.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/permissions_helper.dart';

class ActionSelectionView extends StatefulWidget {
  final HomeLocationResult homeLocationResult;

  ActionSelectionView(this.homeLocationResult);

  @override
  _ActionSelectionViewState createState() => _ActionSelectionViewState();
}

class _ActionSelectionViewState extends State<ActionSelectionView>
    implements PermissionDialogListener {

  var hasRequestedLocationPermission = false;
  final permissionsHelper = new PermissionsHelper();

  Position userPosition;
  UserLocationsBloc _locationBloc;

  @override
  void initState() {
    attemptToRetrieveUserPosition();
    super.initState();

    var locationDatabase = LocationDatabase();
    _locationBloc = UserLocationsBloc(LocationRepository(locationDatabase));
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

  void attemptToRetrieveUserPosition() async {
    var locationPermissionGranted =
        await permissionsHelper.isLocationPermissionGranted();
    if (!locationPermissionGranted && !hasRequestedLocationPermission) {
      requestLocationPermission();
      return;
    } else if (locationPermissionGranted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userPosition = position;
      });
    }
  }

  void requestLocationPermission() async {
    if (await permissionsHelper.requestLocationPermission()) {
      setState(() {
        hasRequestedLocationPermission = true;
      });
    } else {
      permissionsHelper.onLocationPermissionDenied(context, this);
    }
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
                onPressed: () {

                  if (widget.homeLocationResult is HomeLocationSet) {
                    // take user to trip map page
//                    final noticeText = new Text(
//                        "Location: Lat=${(widget.homeLocationResult as HomeLocationSet).location.latitude} Lng=${(widget.homeLocationResult as HomeLocationSet).location.longitude}");
//                    Scaffold.of(context).showSnackBar(new SnackBar(
//                      content: noticeText,
//                    ));
                  } else if (widget.homeLocationResult is HomeLocationNotSet) {
                    Navigator.pushNamed(context, 'home_locator_page/$userPosition');
                  }
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
                onPressed: () {
                  Navigator.pushNamed(context, 'alt_location_page/:$userPosition');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
