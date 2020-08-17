import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmoh_app/ui/blocs/estimate_ride_price.dart';
import 'package:gmoh_app/ui/blocs/trip_route_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:gmoh_app/util/ride_share_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectRideSharePage extends StatefulWidget {
  final TripRouteResult _tripRouteResult;
  final List<RideShareItem> _rides;
  final EstimateRidePrice _estimateRidePrice;


  SelectRideSharePage(this._tripRouteResult, this._rides, this._estimateRidePrice);


  @override
  State<StatefulWidget> createState() =>
      SelectRideSharePageState(_tripRouteResult, this._rides, this._estimateRidePrice);
}

class SelectRideSharePageState extends State<SelectRideSharePage> {
  Completer<GoogleMapController> _controller = Completer();
  final TripRouteResult _tripRouteResult;
  final EstimateRidePrice _estimateRidePrice;
  int isExpandedItemIndex = -1;
  final Map<String, Marker> _markers = {};
  TripRouteBloc _tripRouteBloc;
  Polyline _polyline;
  static const LatLng _DEFAULT_POSITION = LatLng(39.50, -98.35);
  final List<RideShareItem> _rides;
  SelectRideSharePageState(this._tripRouteResult, this._rides, this._estimateRidePrice);


  @override
  Widget build(BuildContext context) {
    final remoteConfigHelper = Provider.of<RemoteConfigHelper>(context);
    _goToStart(_tripRouteResult.origin);
    _addMarkers(_tripRouteResult.origin);
//    final coordinates = _tripRouteResult.routePoints
//        .map((point) => LatLng(point.latitude, point.longitude))
//        .toList();
//    _polyline = Polyline(
//        polylineId: PolylineId("trip"),
//        color: Colors.red,
//        points: coordinates,
//        width: 5
//    );
//    final initialPosition = _tripRouteResult.origin;
    return buildTripConfirmationView(context, LatLng(39.50, -98.35));
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
                          key: GlobalKey(),
                          initiallyExpanded: (index == isExpandedItemIndex),
                          onExpansionChanged: ((isExpanded){
                            if(isExpanded){
                              setState(() {
                                isExpandedItemIndex = index;
                              });
                            }
                          }),
                          leading: CircleAvatar(backgroundImage: AssetImage('${_rides[index].rideShereIcon}'),),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_rides[index].rideShareType,style: TextStyle(color: Colors.white),),
                              Text(_rides[index].rideShareCost,style: TextStyle(color: Colors.white),),
                              Text(_estimateRidePrice.estimateTripPrice().toString(),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                          backgroundColor: Colors.pinkAccent,
                          children: [
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: FlatButton(child: Text("Confirm Ride",
                                style: TextStyle(color: Colors.white
                                ),
                              ),
                                  highlightColor: Colors.transparent,
                                  color: Colors.transparent,
                                  onPressed: () {}
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );},
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
//                polylines: (_polyline != null) ? Set<Polyline>.of({_polyline}) : {},
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
