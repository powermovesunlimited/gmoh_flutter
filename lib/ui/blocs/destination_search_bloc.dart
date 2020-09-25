import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/models/place_search_response.dart';
import 'package:gmoh_app/io/models/places_search_result.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/ui/models/error_model.dart';
import 'package:gmoh_app/ui/models/place_suggestion.dart';
import 'package:rxdart/subjects.dart';

class DestinationSearchBloc {
  final DestinationSearchRepository _searchRepository;
  final PublishSubject<DestinationSearchResult> _subject =
      PublishSubject<DestinationSearchResult>();

  Stream<DestinationSearchResult> getPlaceSuggestionObservable(){
    return _subject.stream;
  }

  DestinationSearchBloc(this._searchRepository);

  searchPlacesByQuery(String searchText, [Position userPosition]) async {
    if (searchText == null || searchText.isEmpty) {
      return _subject.add(DestinationSearchResult(List(), null));
    } else {
      PlaceSearchResponse response =
          await _searchRepository.searchPlacesByQuery(searchText, userPosition);
      if (response.errorMessage == null) {
        final suggestions = response.placeSearchPredictions
            .map((prediction) => PlaceSuggestion(
                prediction.structuredFormatting.mainText,
                prediction.structuredFormatting.secondaryText,
                prediction.placeId))
            .toList();
        _subject.add(DestinationSearchResult(suggestions, null));
      } else {
        _subject.add(
            DestinationSearchResult(List(), ErrorState(response.errorMessage)));
      }
    }
  }

  Future<PlacesSearchDetailsResult> getPlaceDetails(String placeId) async {
    return _searchRepository.fetchPlaceDetails(placeId);
  }
}

class DestinationSearchResult {
  final List<PlaceSuggestion> results;
  final ErrorState errorState;

  DestinationSearchResult(this.results, this.errorState);
}
