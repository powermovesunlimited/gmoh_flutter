import 'package:gmoh_app/io/models/location_model.dart';

abstract class HomeLocationResult {}

class HomeLocationSet implements HomeLocationResult {
  final Location location;
  const HomeLocationSet(this.location);
}

class HomeLocationNotSet implements HomeLocationResult {
  const HomeLocationNotSet();
}