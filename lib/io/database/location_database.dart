import 'dart:async';
import 'dart:io';

import 'package:gmoh_app/io/models/location_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocationDatabase {
  static final LocationDatabase _instance = LocationDatabase._internal();
  factory LocationDatabase() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  LocationDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    return await openDatabase(path, version: 3, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Locations(id STRING PRIMARY KEY, type STRING, longitude DOUBLE, latitude DOUBLE, address STRING)");
    print("Database was Created!");
  }

  addLocation(Location location) async {
    var dbClient = await db;
    int res = await dbClient.insert("Locations", location.toMap());
    print("Location added $res");
    return res;
  }

  getLocations() async {
    final dbClient = await db;
    var res = await dbClient.query('Locations');

    return res.isNotEmpty
        ? res
            .map((entry) => Location(entry["id"], entry["address"], entry["latitude"],
                entry["longitude"], entry["type"]))
            .toList()
        : [];
  }

  Future<Location> getLocationByType(String type) async {
    final dbClient = await db;
    var queryResponse =
        await dbClient.query('Locations', where: 'type = ?', whereArgs: [type]);

    return queryResponse.isNotEmpty
        ? Location(queryResponse.first["id"], queryResponse.first["address"], queryResponse.first["latitude"],
            queryResponse.first["longitude"], getLocationTypeFromString(queryResponse.first["type"]))
        : null;
  }

  updateLocation(Location location) async {
    final dbClient = await db;
    var res = await dbClient.update('Locations', location.toMap(),
        where: 'id = ?', whereArgs: [location.id]);

    return res;
  }

  deleteLocationByType(String type) async {
    final dbClient = await db;
    dbClient.delete('Locations', where: 'type =?', whereArgs: [type]);
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
