import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/trip_route_repo.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:gmoh_app/util/ride_share_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectRideSharePage extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;
  final List<RideShareItem> _rides;

  SelectRideSharePage(this.origin, this.destination, this._rides);

  @override
  State<StatefulWidget> createState() =>
      SelectRideSharePageState(this.origin, this.destination, this._rides);
}

class SelectRideSharePageState extends State<SelectRideSharePage> {
  Completer<GoogleMapController> _controller = Completer();
  int isExpandedItemIndex = -1;
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
  static const LatLng _DEFAULT_POSITION = LatLng(39.50, -98.35);
  final LatLng origin;
  final LatLng destination;
  final List<RideShareItem> _rides;

  SelectRideSharePageState(this.origin, this.destination, this._rides);

  @override
  Widget build(BuildContext context) {
    final remoteConfigHelper = Provider.of<RemoteConfigHelper>(context);
    _tripRouteBloc = TripRouteBloc(
        TripRouteRepository(GoogleApiService(remoteConfigHelper)));
    _goToStart(origin);
    _addMarkers(origin);
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
    controller.moveCamera(CameraUpdate.newCameraPosition(
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background1300.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            _buildGoogleMap(context, initialPosition),
            _buildRideShareItem(),
          ],
        ),
      ),
    );
  }

  _buildRideShareItem() {
    return Expanded(
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          addAutomaticKeepAlives: false,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          itemCount: _rides.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  top: 10.0, right: 20.0, left: 20.0, bottom: 0.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor("#078B91")),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  child: ExpansionTile(
                    key: GlobalKey(),
                    initiallyExpanded: (index == isExpandedItemIndex),
                    onExpansionChanged: ((isExpanded) {
                      if (isExpanded) {
                        setState(() {
                          isExpandedItemIndex = index;
                        });
                      }
                    }),
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('${_rides[index].rideShereIcon}'),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _rides[index].rideShareType,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.pinkAccent,
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: FlatButton(
                            child: Text(
                              "Confirm Ride",
                              style: TextStyle(color: Colors.white),
                            ),
                            highlightColor: Colors.transparent,
                            color: Colors.transparent,
                            onPressed: () {
                              rideshareLauncher(index);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context, LatLng initialPosition) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 72, 0, 0),
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
                polylines:
                    (_polyline != null) ? Set<Polyline>.of({_polyline}) : {},
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
    final endMarker = createMapMarker(destination, "Destination");
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

  void rideshareLauncher(int buttonPosition) {
    if (buttonPosition == 0) {
      _uberNavigator();
    } else
      _lyftNavigator();
  }

  void _lyftNavigator() async {
    final originLat = widget.origin.latitude;
    final originLog = widget.origin.longitude;
    final destinationLat = widget.destination.latitude;
    final destinationLog = widget.destination.longitude;
    final String lyftUrl =
        "lyft://ridetype?id=lyft&pickup[latitude]=$originLat&pickup[longitude]=$originLog&destination[latitude]=$destinationLat&destination[longitude]=$destinationLog";
    if (await canLaunch(lyftUrl)) {
      await launch(lyftUrl);
    } else {
      throw 'Could not launch $lyftUrl';
    }
  }

  void _uberNavigator() async {
    final originLat = widget.origin.latitude;
    final originLog = widget.origin.longitude;
    final destinationLat = widget.destination.latitude;
    final destinationLog = widget.destination.longitude;
    final String uberURL =
        "https://m.uber.com/ul/?action=setPickup&client_id=0B2F-5JcIUyerbTxlVVJWZ2PVW4F22QS&pickup=[latitude]=$originLat&pickup[longitude]=$originLog&dropoff[latitude]=$destinationLat&dropoff[longitude]=$destinationLog";
    if (await canLaunch(uberURL)) {
      await launch(uberURL);
    } else {
      throw 'Could not launch $uberURL';
    }
  }
}
