import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/models/place_search_response.dart';

class DestinationSearchRepository {
  final GoogleApiService _googleApiService;
  DestinationSearchRepository(this._googleApiService);

  Future<PlaceSearchResponse> searchPlacesByQuery(searchText) async {
    return await _googleApiService.searchPlacesByQuery(searchText);
  }
}