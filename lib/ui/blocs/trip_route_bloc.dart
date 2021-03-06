import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gmoh_app/io/models/trip_route_response.dart';
import 'package:gmoh_app/io/repository/trip_route_repo.dart';
import 'package:gmoh_app/ui/models/error_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/subjects.dart';

class TripRouteBloc {
  final PublishSubject<TripRouteResult> _subject =
      PublishSubject<TripRouteResult>();

  get tripRouteObservable => _subject;

  final TripRouteRepository _tripRouteRepository;

  TripRouteBloc(this._tripRouteRepository);

  fetchTripRoute(LatLng destination, LatLng origin) async {
    final TripRouteResponse response =
        await _tripRouteRepository.getTripRoute(origin, destination);
    if (response.errorMessage == null) {
      if (response.directions.routes.isEmpty) {
        _subject.add(TripRouteResult(origin, destination, List.empty(), null));
      } else {
        final pointLatLngs = PolylinePoints().decodePolyline(
            response.directions.routes.first.overviewPolyline.points);
        _subject.add(TripRouteResult(origin, destination, pointLatLngs, null));
      }
    } else {
      _subject.add(TripRouteResult(
          origin, destination, null, ErrorState(response.errorMessage)));
    }
  }
}

class TripRouteResult {
  final LatLng origin;
  final LatLng destination;
  final List<PointLatLng> routePoints;
  final ErrorState errorState;

  TripRouteResult(
      this.origin, this.destination, this.routePoints, this.errorState);
}
