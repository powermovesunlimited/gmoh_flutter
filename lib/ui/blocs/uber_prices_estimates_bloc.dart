import 'dart:async';

import 'package:gmoh_app/io/models/uber_prices_estimates.dart';
import 'package:gmoh_app/io/repository/uber_prices_repo.dart';
import 'package:gmoh_app/util/response.dart';


class UberPricesEstimatesBloc {
  UberPricesRepo _uberPricesRepository;
  StreamController _uberListController;

  StreamSink<Response<UberPricesEstimates>> get uberListSink =>
      _uberListController.sink;

  Stream<Response<UberPricesEstimates>> get chuckListStream =>
      _uberListController.stream;

  UberPricesEstimatesBloc() {
    _uberListController = StreamController<Response<UberPricesEstimates>>();
    _uberPricesRepository = UberPricesRepo();
    fetchUberPrices();
  }

  fetchUberPrices() async {
    uberListSink.add(Response.loading('Getting Uber Prices Estimates.'));
    try {
      UberPricesEstimates uberPricesEsti =
      await _uberPricesRepository.fetchUberPricesEstimatesData();
      uberListSink.add(Response.completed(uberPricesEsti));
    } catch (e) {
      uberListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _uberListController?.close();
  }
}