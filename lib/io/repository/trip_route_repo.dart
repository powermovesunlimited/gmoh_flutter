import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/models/trip_route_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripRouteRepository {
  final GoogleApiService _googleApiService;
  TripRouteRepository(this._googleApiService);

  Future<TripRouteResponse> getTripRoute(LatLng origin, LatLng destination) async {
    return await _googleApiService.fetchTripRoute(origin, destination);
  }
}