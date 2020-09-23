import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'connectivity_status.dart';

class ConnectivityService {

  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    initConnectivity();
  }

  initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    connectionStatusController.add(_getStatusFromResult(result));
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {

    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
