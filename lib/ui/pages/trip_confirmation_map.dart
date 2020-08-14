import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/trip_route_repo.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TripConfirmationMap extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  TripConfirmationMap(this.origin, this.destination);

  @override
  State<StatefulWidget> createState() =>
      TripConfirmationMapState();
}

class TripConfirmationMapState extends State<TripConfirmationMap> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
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
          _tripRouteBloc.fetchTripRoute(widget.destination, widget.origin );
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

  Widget buildTripConfirmationView(
      BuildContext context, LatLng initialPosition) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background1300.png"),
              fit: BoxFit.fill),
        ),
        child: Container(
            child: Stack(
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
            ),
            setupPageTitleCard(),
            setupTripMap(initialPosition),
            setupEditButton(),
            setupContinueButton()
          ],
        )),
      ),
    );
  }

  Container setupContinueButton() {
    return Container(
      margin: EdgeInsets.only(top: 630.0, right: 24.0, left: 220.0),
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
          onPressed: () { },
        ),
      ),
    );
  }

  Container setupEditButton() {
    return Container(
        margin: const EdgeInsets.only(top: 630.0, right: 220.0, left: 24.0),
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
              Navigator.of(context).pop(true);
            },
          ),
        ));
  }

  Container setupTripMap(LatLng initialPosition) {
    return Container(
        margin: const EdgeInsets.only(top: 214.0, right: 24.0, left: 24.0),
        height: 400,
        width: 440,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
        ));
  }

  Container setupPageTitleCard() {
    return Container(
      margin: EdgeInsets.only(top: 36.0),
      child: Container(
        margin: EdgeInsets.only(top: 64.0, right: 24.0, left: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [HexColor("#078B91"), HexColor("#336D6B")]),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 88,
          child: Center(
            child: Text(
              "Your Trip Map",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
}
