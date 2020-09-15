import 'package:gmoh_app/io/models/places_search_result.dart';

class PlaceDetailsResponse {
  final PlacesSearchDetailsResult result;

  final String errorMessage;

  PlaceDetailsResponse(this.result, this.errorMessage);

  factory PlaceDetailsResponse.fromJson(Map json) => json != null
      ? PlaceDetailsResponse(
           PlacesSearchDetailsResult.fromJson(json['result']), null)
      : null;

  PlaceDetailsResponse.onError(error)
      : errorMessage = error,
        result = null;
}
