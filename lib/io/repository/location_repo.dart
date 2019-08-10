import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/location_model.dart';

class LocationRepository {
  final LocationDatabase _database;
  LocationRepository(this._database);

  Future<Location> getHomeLocation() async {
    return await _database.getLocationByType('home');
  }

  saveHomeLocation(Location location) async {
    _database.addLocation(location);
  }
}