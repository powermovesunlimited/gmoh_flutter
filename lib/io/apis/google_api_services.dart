import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/models/place_details_response.dart';
import 'package:gmoh_app/io/models/place_search_response.dart';
import 'package:gmoh_app/io/models/trip_route_response.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class GoogleApiService {
  static const _DOMAIN = "https://maps.googleapis.com/";
  static const _PLACES_AUTOCOMPLETE_ENDPOINT =
      "maps/api/place/autocomplete/json";
  static const _PLACES_DETAILS_ENDPOINT = "maps/api/place/details/json";
  static const _DIRECTIONS_ENDPOINT = "maps/api/directions/json";
  final Dio _dioClient = Dio();
  final RemoteConfigHelper remoteConfigHelper;


  GoogleApiService(this.remoteConfigHelper);

  Future<PlaceSearchResponse> searchPlacesByQuery(searchText,
      [Position userPosition]) async {
    String apiKey = remoteConfigHelper.googleApiKey;
    try {
      Response response = await _dioClient.get(_buildPlaceSearchEndPoint(
          searchText, apiKey, userPosition));
      final json = response.data;
      if (json != null) {
        return PlaceSearchResponse.fromJson(json);
      } else {
        return PlaceSearchResponse.onError(
            "Response data was empty: ${response.data['status']}");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PlaceSearchResponse.onError(error);
    }
  }

  Future<PlaceDetailsResponse> fetchPlaceDetails(placeId) async {
    String apiKey = remoteConfigHelper.googleApiKey;
    try {
      Response response = await _dioClient
          .get(_buildPlaceDetailsEndPoint(placeId, apiKey));
      final json = response.data;
      if (json != null) {
        return PlaceDetailsResponse.fromJson(json);
      } else {
        return PlaceDetailsResponse.onError(
            "Response data was empty: ${response.data['status']}");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PlaceDetailsResponse.onError(error);
    }
  }

  Future<TripRouteResponse> fetchTripRoute(
      LatLng originLatLng, LatLng destinationLatLng) async {
    if (remoteConfigHelper == null) return TripRouteResponse.onError("remoteConfig is null");
    String apiKey = remoteConfigHelper.googleApiKey;
    try {
      final path = _buildDirectionsEndPoint(
          originLatLng.asStringCoordinates(),
          destinationLatLng.asStringCoordinates(),
          apiKey);
      Response response = await _dioClient.get(path);
      final json = response.data;
      if (json != null) {
        return TripRouteResponse.fromJson(json);
      } else {
        return TripRouteResponse.onError(
            "Response data was empty: ${response.data['status']}");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return TripRouteResponse.onError(error);
    }
  }

  String _buildPlaceSearchEndPoint(searchText, apiKey,
      [Position userPosition]) {
    if (userPosition != null) {
      return "$_DOMAIN$_PLACES_AUTOCOMPLETE_ENDPOINT?input=$searchText&key=$apiKey&location=${userPosition.latitude},${userPosition.longitude}";
    } else {
      return "$_DOMAIN$_PLACES_AUTOCOMPLETE_ENDPOINT?input=$searchText&key=$apiKey";
    }
  }

  String _buildPlaceDetailsEndPoint(placeId, apiKey) {
    return "$_DOMAIN$_PLACES_DETAILS_ENDPOINT?place_id=$placeId&key=$apiKey";
  }

  String _buildDirectionsEndPoint(origin, destination, apiKey) {
    return "$_DOMAIN$_DIRECTIONS_ENDPOINT?origin=$origin&destination=$destination&key=$apiKey";
  }
}

extension on LatLng {
  String asStringCoordinates() => "${this.latitude},${this.longitude}";
}
