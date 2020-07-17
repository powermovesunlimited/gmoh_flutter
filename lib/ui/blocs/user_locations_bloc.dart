import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class UserLocationsBloc implements BlocBase {
  final LocationRepository _repository;
  final PublishSubject<Location> _resultSubject =
      PublishSubject<Location>();


  Stream<Location> getLocationDataObservable() {
    return _resultSubject.stream;
  }

  UserLocationsBloc(this._repository);

  @override
  void dispose() {
    _repository.dispose();
    _resultSubject.close();
  }

  getHomeLocation() async {
    Location location = await _repository.getHomeLocation();
    if(location != null){
      _resultSubject.add(location);
    }
  }

  Future<void> setHomeLocation(String address, double latitude, double longitude) async {
    final homeLocation = Location(
        0,
        address,
        latitude,
        longitude,
        LocationType.HOME
    );
    var currentLocation = await _repository.getHomeLocation();
    if(currentLocation == null) {
      _repository.saveHomeLocation(homeLocation);
    }else{
      _repository.updateHomeLocation(homeLocation);
    }
  }
}
