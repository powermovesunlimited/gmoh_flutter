import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/trip_route_repo.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final LatLng _targetDestination;
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
  static const LatLng _DEFAULT_POSITION = LatLng(39.50, -98.35);

  TripConfirmationMapState(this._targetDestination);

  @override
  void initState() {
    _tripRouteBloc = TripRouteBloc(TripRouteRepository(GoogleApiService()));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              width: 5
          );
        } else {
          _tripRouteBloc.fetchTripRoute(_targetDestination);
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
          polylines: (_polyline != null) ? Set<Polyline>.of({_polyline}) : {},
        ));
  }

  void _addMarkers(LatLng initialPosition) {
    _markers.clear();
    final startMarker = createMapMarker(
        LatLng(initialPosition.latitude, initialPosition.longitude), "Start");
    final endMarker = createMapMarker(
        LatLng(_targetDestination.latitude, _targetDestination.longitude),
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
