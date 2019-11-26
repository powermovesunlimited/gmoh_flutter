import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TripConfirmationMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  TripConfirmationMap(this.latitude, this.longitude);

  @override
  State<StatefulWidget> createState() =>
      TripConfirmationMapState(LatLng(latitude, longitude));
}

class TripConfirmationMapState extends State<TripConfirmationMap> {
  Completer<GoogleMapController> _controller = Completer();
  final LatLng targetDestination;
  final Map<String, Marker> _markers = {};

  TripConfirmationMapState(this.targetDestination);

  Future<LatLng> _requestUserLocation(BuildContext context) async {
    Position currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _requestUserLocation(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data != null) {
            _goToStart(snapshot.data);
            addMarkers(snapshot.data);
          }
        return buildTripConfirmationView(context, LatLng(39.50, -98.35));
      },
    );
  }

  Future<void> _goToStart(LatLng start) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: start, zoom: 12)));
  }

  Widget buildTripConfirmationView(
      BuildContext context, LatLng initialPosition) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Plan Confirmation'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context, initialPosition),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.flag),
        onPressed: () {},
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context, LatLng initialPosition) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  void addMarkers(LatLng initialPosition) {
    _markers.clear();
    final startMarker = createMapMarker(
        LatLng(initialPosition.latitude, initialPosition.longitude),
        "Start");
    final endMarker = createMapMarker(
        LatLng(targetDestination.latitude, targetDestination.longitude),
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
