import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class DrawerBloc implements BlocBase {
  final LocationRepository _repository;
  final PublishSubject<String> _resultSubject =
  PublishSubject<String>();

  Stream<String> getAddressAsObservable(){
    return _resultSubject.stream;
  }



  DrawerBloc(this._repository);

  @override
  void dispose() {
    _repository.dispose();
    _resultSubject.close();
  }

  getHomeLocation() async {
    Location location = await _repository.getHomeLocation();
    if (location != null) {
      _resultSubject.add(location.address);
    }
  }
}