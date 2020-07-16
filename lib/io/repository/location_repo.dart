import 'package:flutter/foundation.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/location_model.dart';

class LocationRepository {
  final LocationDatabase _database;
  LocationRepository(this._database);

  Future<Location> getHomeLocation() {
    return _database.getLocationByType(describeEnum(LocationType.HOME));
  }

  saveHomeLocation(Location location) async {
    _database.addLocation(location);
  }

  void dispose(){
    _database.closeDb();
  }
}