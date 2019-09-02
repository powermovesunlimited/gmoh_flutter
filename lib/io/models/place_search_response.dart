import 'package:google_maps_webservice/places.dart';

class PlaceSearchResponse {
  final List<Prediction> placeSearchPredictions;

  final String errorMessage;

  PlaceSearchResponse(this.placeSearchPredictions, this.errorMessage);

  factory PlaceSearchResponse.fromJson(Map json) => json != null
      ? PlaceSearchResponse(
          (json['predictions'] as List)
              .map((i) => Prediction.fromJson(i))
              .toList(),
          null)
      : null;

  PlaceSearchResponse.onError(error)
      : errorMessage = error,
        placeSearchPredictions = null;
}
