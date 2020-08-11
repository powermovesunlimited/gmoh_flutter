import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/drawer_bloc.dart';
import 'package:gmoh_app/ui/models/locator_page_model.dart';
import 'package:gmoh_app/util/hex_color.dart';

class HomeMenuDrawer extends StatefulWidget {
  const HomeMenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer>
    with WidgetsBindingObserver {
  DrawerBloc _drawerBloc;


  @override
  void initState() {
    super.initState();
    var locationDatabase = LocationDatabase();
    _drawerBloc = DrawerBloc(LocationRepository(locationDatabase));
    _drawerBloc.getHomeLocation();
    WidgetsBinding.instance.addObserver(this);
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
                  DrawerHeader(
                      child: Row(
                    children: [
                      Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, color: Colors.pinkAccent),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/profileImage.jpg'),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment(.9, .6),
                        child: Text(
                          "Im a Rida",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
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
                              Navigator.pushNamed(context,
                                  'home_locator_page/${getStringFromEnum(HomeLocationPageMode.HOME_LOCATION)}');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, right: 0.0, left: 0.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pinkAccent,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, right: 0.0, left: 0.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pinkAccent,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Help",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
//
//   Use the commented code below when you need to manually navate to a different page just update the navitagator and Text
//
//                  ListTile(
//                    title: Container(
//                      margin: EdgeInsets.only(
//                          top: 10.0, right: 0.0, left: 0.0, bottom: 10.0),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(10),
//                        color: Colors.pinkAccent,
//                      ),
//                      child: FlatButton(
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(12)),
//                        child: Text(
//                          'RIDE SHARE',
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 14,
//                              fontFamily: 'Montserrat',
//                              fontWeight: FontWeight.w400),
//                        ),
//                        color: Colors.pinkAccent,
//                        textColor: Colors.white,
//                        onPressed: () {
//                          final testRoute = TripRouteResult(LatLng(39.50, -98.35), LatLng(39.50, -98.35), null, null);
//                          final rideShareRides = RidesList().rides;
//                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectRideSharePage(testRoute, rideShareRides)));
//                        },
//                      ),
//                    ),
//                  ),
                ],
              ),
            ),
          );
        });
  }
}
