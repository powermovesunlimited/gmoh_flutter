import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/models/place_search_response.dart';
import 'package:google_maps_webservice/src/places.dart';

class DestinationSearchRepository {
  final GoogleApiService _googleApiService;
  DestinationSearchRepository(this._googleApiService);

  Future<PlaceSearchResponse> searchPlacesByQuery(searchText, [Position userPosition]) async {
    return await _googleApiService.searchPlacesByQuery(searchText, userPosition);
  }

  Future<PlacesSearchResult> fetchPlaceDetails(String placeId) async{
    final details = (await _googleApiService.fetchPlaceDetails(placeId)).result;
    return details;
  }
}