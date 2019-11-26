import 'package:google_maps_webservice/places.dart';

class PlaceDetailsResponse {
  final PlacesSearchResult result;

  final String errorMessage;

  PlaceDetailsResponse(this.result, this.errorMessage);

  factory PlaceDetailsResponse.fromJson(Map json) => json != null
      ? PlaceDetailsResponse(
           PlacesSearchResult.fromJson(json['result']), null)
      : null;

  PlaceDetailsResponse.onError(error)
      : errorMessage = error,
        result = null;
}
