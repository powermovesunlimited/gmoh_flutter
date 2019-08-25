import 'package:flutter_test/flutter_test.dart';
import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/locations_bloc.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

main() => {
  test('test repository should return saved home location',() async {
    const TEST_LAT = 37.2343 ;
    const TEST_LNG = -115.8067;
    final testHomeLocation = Location(
      0,
      TEST_LNG,
      TEST_LAT,
      LocationType.HOME
     );

    final LocationRepository mockLocationRepository = _MockLocationRepository();

    when(mockLocationRepository.getHomeLocation())
      .thenAnswer((_) => Future.value(testHomeLocation));

    final locationBloc = LocationsBloc(mockLocationRepository);

    scheduleMicrotask((){
      locationBloc.getHomeLocation();
    });

   await expectLater(
      locationBloc.locationDataObservable.stream
    , emits(testHomeLocation));
  })
};

class _MockLocationRepository extends Mock implements LocationRepository {}