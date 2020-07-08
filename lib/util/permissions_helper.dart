import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionDialogListener {
  void onRequestPermission();
  void onPermissionDenied();
}

class PermissionsHelper {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> requestLocationPermission() async {
    return _requestPermission(PermissionGroup.locationWhenInUse);
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> isLocationPermissionGranted() async {
    return hasPermission(PermissionGroup.locationWhenInUse);
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  void onLocationPermissionDenied(
      BuildContext context, PermissionDialogListener listener) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: const Text(
                'Location Permission is needed to determine where to pick you up. Do you want to enable it?'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  listener.onPermissionDenied();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  listener.onRequestPermission();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
