import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/locations_bloc.dart';

class LocatorPage extends StatefulWidget {
  static const String routeName = "/locatorPage";
  final bool isGoingHome;

  LocatorPage(this.isGoingHome);

  _LocatorPageState createState() => _LocatorPageState();
}

class _LocatorPageState extends State<LocatorPage> {
  LocationsBloc bloc = LocationsBloc(LocationRepository(LocationDatabase()));

  @override
  void initState() {
    super.initState();
    bloc.getHomeLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
