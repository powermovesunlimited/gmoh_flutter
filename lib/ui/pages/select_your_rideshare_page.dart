import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:gmoh_app/util/ride_share_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectRideSharePage extends StatefulWidget {
  final TripRouteResult _tripRouteResult;


  SelectRideSharePage(this._tripRouteResult);

  @override
  State<StatefulWidget> createState() =>
      SelectRideSharePageState(_tripRouteResult);
}

class SelectRideSharePageState extends State<SelectRideSharePage> {
  Completer<GoogleMapController> _controller = Completer();
  final TripRouteResult _tripRouteResult;
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
  static const LatLng _DEFAULT_POSITION = LatLng(39.50, -98.35);

  SelectRideSharePageState(this._tripRouteResult);

  List<RideShareItem> rides = [
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$14.45'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$10.15'),
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$7.83'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$42.99'),
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$14.45'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$10.15'),
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$7.83'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$42.99'),
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$14.45'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$10.15'),
    RideShareItem(rideShereIcon: 'assets/images/uberIcon.png', rideShareType: 'UBER', rideShareCost: '\$7.83'),
    RideShareItem(rideShereIcon: 'assets/images/lyftIcon.png', rideShareType: 'Lyft', rideShareCost: '\$42.99'),
  ];



  @override
  Widget build(BuildContext context) {
    final remoteConfigHelper = Provider.of<RemoteConfigHelper>(context);
    _goToStart(_tripRouteResult.origin);
    _addMarkers(_tripRouteResult.origin);
    final coordinates = _tripRouteResult.routePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    _polyline = Polyline(
        polylineId: PolylineId("trip"),
        color: Colors.red,
        points: coordinates,
        width: 5
    );
    final initialPosition = _tripRouteResult.origin;
    return buildTripConfirmationView(context, initialPosition);
  }

  Future<void> _goToStart(LatLng start) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: start, zoom: 12)));
  }

  Widget buildTripConfirmationView(
      BuildContext context, LatLng initialPosition) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Exit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context, initialPosition),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context, LatLng initialPosition) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background1300.png"),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
          Expanded(
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                itemCount: rides.length,
                itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.only(
                      top: 10.0, right: 20.0, left: 20.0, bottom: 0.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor("#078B91")
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      child: ExpansionTile(
                        leading: CircleAvatar(backgroundImage: AssetImage('${rides[index].rideShereIcon}'),),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(rides[index].rideShareType,style: TextStyle(color: Colors.white),),
                            Text(rides[index].rideShareCost,style: TextStyle(color: Colors.white),)
                          ],
                        ),
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  ),
                );},
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMarkers(LatLng initialPosition) {
    _markers.clear();
    final startMarker = createMapMarker(
        LatLng(initialPosition.latitude, initialPosition.longitude), "Start");
    final endMarker = createMapMarker(
        LatLng(_tripRouteResult.destination.latitude, _tripRouteResult.destination.longitude),
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
