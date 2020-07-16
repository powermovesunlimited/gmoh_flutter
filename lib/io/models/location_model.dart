import 'package:flutter/foundation.dart';

class Location{
  final int id;
  final String address;
  final double longitude;
  final double latitude;
  final LocationType type;
  Location(this.id, this.address, this.longitude, this.latitude, this.type);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['type'] = describeEnum(type);
    return map;
  }
}

enum LocationType {
  HOME,
}

LocationType getLocationTypeFromString(String type) {
  return LocationType.values
      .firstWhere((mode) => _getTypeStringFromEnum(mode) == type);
}

String _getTypeStringFromEnum(LocationType type){
  return type.toString().substring(type.toString().indexOf('.')+1);
}