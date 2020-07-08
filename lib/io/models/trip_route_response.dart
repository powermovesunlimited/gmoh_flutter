import 'package:google_maps_webservice/directions.dart';

class TripRouteResponse {
  final DirectionsResponse directions;

  final String errorMessage;

  TripRouteResponse(this.directions, this.errorMessage);

  factory TripRouteResponse.fromJson(Map json) => json != null
      ? TripRouteResponse(DirectionsResponse.fromJson(json), null)
      : null;

  TripRouteResponse.onError(error)
      : errorMessage = error,
        directions = null;
}
