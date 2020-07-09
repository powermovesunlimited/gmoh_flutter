import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/home_location_result.dart';
import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/ui/pages/action_selection_view.dart';

class ActionSelectionPage extends StatefulWidget {
  @override
  _ActionSelectionPageState createState() => _ActionSelectionPageState();
}

class _ActionSelectionPageState extends State<ActionSelectionPage> {
  bool hasLoaded = false;
  UserLocationsBloc _locationBloc;

  @override
  void initState() {
    super.initState();
    var locationDatabase = LocationDatabase();
    locationDatabase.initDB();
    _locationBloc = UserLocationsBloc(LocationRepository(locationDatabase));
  }

  @override
  void dispose() {
    super.dispose();
    _locationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  //Todo
                });
          },
        ),
      ),
      body: StreamBuilder(
        stream: _locationBloc.locationDataObservable.stream,
        builder: (BuildContext context, AsyncSnapshot<Location> snapshot) {
          if (snapshot.hasData) {
            return ActionSelectionView(HomeLocationSet(snapshot.data));
          } else if (!hasLoaded) {
            _locationBloc.getHomeLocation();
            hasLoaded = true;
          }
          return ActionSelectionView(HomeLocationNotSet());
        },
      ),
    );
  }
}
