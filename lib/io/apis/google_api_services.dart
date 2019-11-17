import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/models/place_search_response.dart';
import 'package:gmoh_app/util/secret_loader.dart';

class GoogleApiService {
  final String _domain = "https://maps.googleapis.com/";
  final Dio _dioClient = Dio();

  Future<PlaceSearchResponse> searchPlacesByQuery(searchText,
      [Position userPosition]) async {
    final secret = await SecretLoader(secretPath: "secrets.json").load();
    try {
      Response response = await _dioClient.get(_buildPlaceSearchEndPoint(
          searchText, secret.googleApiKey, userPosition));
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

  String _buildPlaceSearchEndPoint(searchText, apiKey,
      [Position userPosition]) {
    if (userPosition != null) {
      return "${_domain}maps/api/place/autocomplete/json?input=$searchText&key=$apiKey&location=${userPosition.latitude},${userPosition.longitude}";
    } else {
      return "${_domain}maps/api/place/autocomplete/json?input=$searchText&key=$apiKey";
    }
  }
}
