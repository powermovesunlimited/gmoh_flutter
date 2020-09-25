import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionDialogListener {
  void onRequestPermission();

  void onPermissionDenied();
}

class PermissionsHelper {
  var userLocation;

  requestLocationPermission() async {
    return await Permission.location.request();
  }

  Future<bool> isLocationPermissionGranted() {
    return Permission.location.isGranted;
  }


  Future<String> onLocationPermissionDenied(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Needed'),
            content: const Text(
                'Location Permission is needed to determine where to pick you up. Do you want to enable it?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () async {
                  Navigator.pop(context, "navigateDestination");
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () async {
                  Permission.location.isGranted;
                  final Geolocator geolocator = Geolocator()
                    ..forceAndroidLocationManager = true;
                  await geolocator
                      .getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high)
                      .then((result) {
                    Navigator.pop(context, result);
                  });
                },
              )
            ],
          );
        });
  }

  void onLocationPermissionPermanentlyDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Location Needed"),
              content: Text(
                  "Location Permission is needed to determine where to pick you up. Do you want to enable it?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Go to Setting'),
                  onPressed: () async {
                    AppSettings.openAppSettings();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
