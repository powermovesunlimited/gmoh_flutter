class Location{
  final int id;
  final double longitude;
  final double latitude;
  final String type;
  Location(this.id, this.longitude, this.latitude, this.type);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['type'] = type;
    return map;
  }
}