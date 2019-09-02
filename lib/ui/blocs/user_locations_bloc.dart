import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class UserLocationsBloc implements BlocBase {
  final LocationRepository _repository;
  final PublishSubject<Location> _resultSubject =
      PublishSubject<Location>();
  get locationDataObservable => _resultSubject;

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

  void setHomeLocation(double longitude, double latitude){
    final homeLocation = Location(
      null,
      longitude,
      latitude,
      LocationType.HOME
    );
    _repository.saveHomeLocation(homeLocation);
  }
}
