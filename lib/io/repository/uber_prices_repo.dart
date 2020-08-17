import 'dart:async';
import 'package:gmoh_app/io/apis/uber_api_services.dart';
import 'package:gmoh_app/io/models/uber_prices_estimates.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

class UberPricesRepo {

  ApiProvider _provider = ApiProvider();

  Future<UberPricesEstimates> fetchUberPricesEstimatesData() async {
    final response = await _provider.get("/v1.2/products?latitude=37.7752315&longitude=-122.418075", head(url));
    return UberPricesEstimates.fromJson(response);
  }
}