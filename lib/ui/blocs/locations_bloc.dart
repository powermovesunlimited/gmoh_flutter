import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class LocationsBloc implements BlocBase {
  final LocationRepository _repository;
  final PublishSubject<List<Location>> _resultSubject =
      PublishSubject<List<Location>>();
  get locationDataObservable => _resultSubject;

  LocationsBloc(this._repository);

  @override
  void dispose() {
    _resultSubject.close();
  }

  void getHomeLocation() async {
    Location location = await _repository.getHomeLocation();
    if(location != null){
      _resultSubject.add(List.of([location]));
    }
  }

  void setHomeLocation(double longitude, double latitude){
    final homeLocation = Location(
      null,
      longitude,
      latitude,
      'home'
    );
    _repository.saveHomeLocation(homeLocation);
  }
}
