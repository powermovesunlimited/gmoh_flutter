import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/drawer_bloc.dart';
import 'package:mockito/mockito.dart';

main() => {
  test('test repository should return saved home location',() async {
    const TEST_ADDRESS = "6024 Halifax Place Brookln center MN 55429" ;
    const TEST_LAT = 37.2343 ;
    const TEST_LNG = -115.8067;
    final testHomeLocation = Location(
        0,
        TEST_ADDRESS,
        TEST_LNG,
        TEST_LAT,
        LocationType.HOME
    );

    final LocationRepository mockLocationRepository = _MockLocationRepository();

    when(mockLocationRepository.getHomeLocation())
        .thenAnswer((_) => Future.value(testHomeLocation));

    final drawerBloc = DrawerBloc(mockLocationRepository);

    scheduleMicrotask((){
      drawerBloc.getHomeLocation();
    });

    await expectLater(
        drawerBloc.getAddressAsObservable()
        , emits(testHomeLocation.address));
  })
};

class _MockLocationRepository extends Mock implements LocationRepository {}