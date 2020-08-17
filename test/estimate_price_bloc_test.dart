import 'package:flutter_test/flutter_test.dart';
import 'package:gmoh_app/ui/blocs/estimate_ride_price.dart';

main() => {
      test('test should return an estimated price', () async {
        const testCostPerMile = 1.5;
        const testTotalTripMiles = 20.4;
        const testBaseTripPrice = 15.1;
        const testNumberOfRiders = 4;

        final testEstimateRidePrice = EstimateRidePrice(
          testCostPerMile,
          testTotalTripMiles,
          testBaseTripPrice,
          testNumberOfRiders
        );
      })
    };