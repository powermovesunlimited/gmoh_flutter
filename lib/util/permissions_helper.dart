import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionDialogListener {
  void onRequestPermission();
  void onPermissionDenied();
}

class PermissionsHelper {

  requestLocationPermission() {
    return Permission.location.request();
  }

  Future<bool> isLocationPermissionGranted() {
    return Permission.location.isGranted;
  }

  void onLocationPermissionDenied(
      BuildContext context, PermissionDialogListener listener) {
    showDialog(
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
                onPressed: () {
                  listener.onPermissionDenied();
                  Navigator.popAndPushNamed(context, 'current_user_location');
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  listener.onRequestPermission();
                },
              )
            ],
          );
        });
  }
}
