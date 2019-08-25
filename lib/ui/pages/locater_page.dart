import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/locations_bloc.dart';

class LocatorPage extends StatefulWidget {
  static const String routeName = "/locatorPage";

  LocatorPage();

  _LocatorPageState createState() => _LocatorPageState();
}

class _LocatorPageState extends State<LocatorPage> {
  LocationsBloc bloc = LocationsBloc(LocationRepository(LocationDatabase()));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Container ();
=======
    return Container(
      child: Container(),
    );
>>>>>>> implement action selection page, add location bloc test
  }
}
