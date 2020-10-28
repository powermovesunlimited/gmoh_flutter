import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/trip_route_repo.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/locator/alt_location_page.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/ui/pages/ride_party_page.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/permissions_helper.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TripConfirmationMap extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;
  final RouteIntent intent;

  TripConfirmationMap(this.origin, this.destination, this.intent,);

  @override
  State<StatefulWidget> createState() => TripConfirmationMapState();
}

class TripConfirmationMapState extends State<TripConfirmationMap> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
  Position userPosition;
  var hasRequestedLocationPermission = false;
  final permissionsHelper = new PermissionsHelper();

  static const LatLng _DEFAULT_POSITION = LatLng(39.50, -98.35);

  TripConfirmationMapState();

  @override
  Widget build(BuildContext context) {
    final remoteConfigHelper = Provider.of<RemoteConfigHelper>(context);
    _tripRouteBloc = TripRouteBloc(
        TripRouteRepository(GoogleApiService(remoteConfigHelper)));
    return StreamBuilder(
      stream: _tripRouteBloc.tripRouteObservable.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          TripRouteResult result = snapshot.data;
          _goToStart(result.origin);
          _addMarkers(result.origin);
          final coordinates = result.routePoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          _polyline = Polyline(
              polylineId: PolylineId("trip"),
              color: Colors.red,
              points: coordinates,
              width: 5);
        } else {
          _tripRouteBloc.fetchTripRoute(widget.destination, widget.origin);
        }
        return buildTripConfirmationView(context, _DEFAULT_POSITION);
      },
    );
  }

  Future<void> _goToStart(LatLng start) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: start, zoom: 12)));
  }

  Widget buildTripConfirmationView(BuildContext context,
      LatLng initialPosition) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActionSelectionPage(),
            ));
        return true;
      },
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background1300.png"),
                fit: BoxFit.fill),
          ),
          child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: false,
                  title: const Text('Exit'),
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActionSelectionPage()));
                    },
                  ),
                  elevation: 0,
                ),
                body: Column(
                  children: <Widget>[
                    setupPageTitleCard(),
                    setupTripMap(initialPosition),
                    Container(
                  margin: EdgeInsets.fromLTRB(24, 12, 24, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: setupEditButton()),
                      Expanded(flex: 1, child: setupContinueButton())
                    ],
                  ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container setupContinueButton() {
    return Container(
      margin: EdgeInsets.only(top: 0.0, right: 0, left: 4, bottom: 0.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Continue",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400)),
              Icon(Icons.chevron_right),
            ],
          ),
          color: Colors.pinkAccent,
          textColor: Colors.white,
          elevation: 4,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RidePartyPage(widget.origin, widget.destination),
              ),
            );
          },
        ),
      ),
    );
  }

  Container setupEditButton() {
    return Container(
        margin: const EdgeInsets.only(top: 0.0, right: 4, left: 0.0, bottom: 0.0),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: RaisedButton(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left),
                Text("Edit",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400)),
              ],
            ),
            color: Colors.pinkAccent,
            textColor: Colors.white,
            elevation: 4,
            onPressed: () {
              editDestination();
            },
          ),
        ));
  }

  Expanded setupTripMap(LatLng initialPosition) {
    return Expanded(
      flex: 5,
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height / 1.5,
        margin: EdgeInsets.fromLTRB(24, 12, 24, 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers.values.toSet(),
            myLocationEnabled: true,
            polylines: (_polyline != null) ? Set<Polyline>.of({_polyline}) : {},
          ),
        ),
      ),
    );
  }

  Container setupPageTitleCard() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [HexColor("#078B91"), HexColor("#336D6B")]),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 96,
          child: Center(
            child: Text(
              "Your Trip Map",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  void _addMarkers(LatLng initialPosition) {
    _markers.clear();
    final startMarker = createMapMarker(
        LatLng(initialPosition.latitude, initialPosition.longitude), "Start");
    final endMarker = createMapMarker(
        LatLng(widget.destination.latitude, widget.destination.longitude),
        "Destination");
    _markers[startMarker.markerId.toString()] = startMarker;
    _markers[endMarker.markerId.toString()] = endMarker;
  }

  Marker createMapMarker(LatLng latLng, String title) {
    return Marker(
      markerId: MarkerId(title),
      position: latLng,
      infoWindow: InfoWindow(title: title),
    );
  }

  Future editDestination() async {
    RouteData routeData = RouteData();

    routeData.origin = LatLng(widget.origin.latitude, widget.origin.longitude);
    routeData.destination = LatLng(widget.origin.latitude, widget.origin.longitude);

    print("trip map intent is ${widget.intent}");
    if (widget.intent is GoHome) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeLocatorPage(routeData, widget.intent),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlternateLocationPage(routeData, widget.intent),
          ));
    }
  }
}
