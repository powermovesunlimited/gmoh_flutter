import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/drawer_bloc.dart';
import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/util/connectivity_status.dart';
import 'package:gmoh_app/util/hex_color.dart';

class HomeMenuDrawer extends StatefulWidget {
  final ConnectivityStatus _connectivityStatus;
  const HomeMenuDrawer(this._connectivityStatus, {
    Key key,
  }) : super(key: key);

  @override
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer>
    with WidgetsBindingObserver {
  DrawerBloc _drawerBloc;
  bool isInternetConnectivityAvailable;

  RouteIntent get intent => null;


  @override
  void initState() {
    super.initState();
    var locationDatabase = LocationDatabase();
    _drawerBloc = DrawerBloc(LocationRepository(locationDatabase));
    _drawerBloc.getHomeLocation();
    WidgetsBinding.instance.addObserver(this);
  }

  void showNoConnectivityDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("You are offline. \n"
              "Please enable Mobile Data or Wifi inorder to use this application"),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                AppSettings.openDataRoamingSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _drawerBloc.getHomeLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _drawerBloc.getAddressAsObservable(),
        builder: (context, snapshot) {
          var address = snapshot.data;
          return Drawer(
            child: Container(
              color: HexColor("#2B2C2C"),
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 50.0, right: 15.0, left: 15.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 24.0,
                                    right: 15.0,
                                    left: 15.0,
                                    bottom: 10.0),
                                child: Text(
                                  address != null
                                      ? address
                                      : "No Home Address Set",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ))),
                        Container(
                          margin: EdgeInsets.only(
                              top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
                          width: double.infinity,
                          height: 40,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'Edit Address',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                            ),
                            color: Colors.pinkAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              handleEditAddressClick(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void handleEditAddressClick(BuildContext context) async {
    final connectivityResult = widget._connectivityStatus;
    if (connectivityResult == ConnectivityStatus.Cellular ||
        connectivityResult == ConnectivityStatus.WiFi) {
      isInternetConnectivityAvailable = true;
    } else {
      isInternetConnectivityAvailable = false;
    }
    RouteData route = RouteData();
    isInternetConnectivityAvailable?
    launchHomeLocatorPage(context, route) : showNoConnectivityDialog();
  }

  Future launchHomeLocatorPage(BuildContext context, RouteData route) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeLocatorPage(
            route,
            GoHomePage(),
          ),
        ));
  }
}
