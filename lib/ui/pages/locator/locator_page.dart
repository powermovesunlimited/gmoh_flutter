import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/ui/blocs/user_locations_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/permissions_helper.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

abstract class LocatorPage extends StatefulWidget {
  LocatorPage();

  LocatorPageState createState();
}

class LocatorPageState extends State<LocatorPage>
    implements PermissionDialogListener {
  LocatorPageState();

  UserLocationsBloc _locationBloc;

  DestinationSearchBloc _bloc;

  var hasRequestedLocationPermission = false;
  final onTextChangedListener = new PublishSubject<String>();
  final permissionsHelper = new PermissionsHelper();
  Position userPosition;

  @override
  void initState() {
    onTextChangedListener.distinct().listen((searchText) {
      getLocationResults(searchText);
    });
    attemptToRetrieveUserPosition();
    super.initState();
    var locationDatabase = LocationDatabase();
    _locationBloc = UserLocationsBloc(LocationRepository(locationDatabase));
  }

  @override
  void onPermissionDenied() {
    hasRequestedLocationPermission = true;
  }

  @override
  void onRequestPermission() {
    setState(() {
      permissionsHelper.requestLocationPermission();
      hasRequestedLocationPermission = true;
    });
  }

  void attemptToRetrieveUserPosition() async {
    var locationPermissionGranted =
        await permissionsHelper.isLocationPermissionGranted();
    if (!locationPermissionGranted && !hasRequestedLocationPermission) {
      requestLocationPermission();
      return;
    } else if (locationPermissionGranted) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        userPosition = position;
      });
    }
  }

  void requestLocationPermission() async {
    await permissionsHelper.requestLocationPermission();
    if (await permissionsHelper.isLocationPermissionGranted()) {
      setState(() {
        hasRequestedLocationPermission = true;
      });
    } else {
      permissionsHelper.onLocationPermissionDenied(context, this);
    }
  }

  Widget buildContentView(DestinationSearchResult searchResult) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background1300.png"),
              fit: BoxFit.fill),
        ),
        child: Container(
          child: Stack(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
              ),
              Container(
                margin: EdgeInsets.only(top: 36.0),
                child: Container(
                  margin: EdgeInsets.only(top: 64.0, right: 24.0, left: 24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [HexColor("#078B91"), HexColor("#336D6B")]),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 88,
                    child: Center(
                      child: Text(
                        getAppBarTitle(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  child: searchResult != null
                      ? buildSuggestionList(searchResult)
                      : Container()),
              Container(
                child: Card(
                  margin: const EdgeInsets.only(
                      top: 212.0, right: 24.0, left: 24.0),
                  color: Colors.white,
                  elevation: 10,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: getHintText(),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                    onChanged: (searchText) {
                      onTextChangedListener.add(searchText);
                    },
                  ),
                ),
              ),
              Container(
                  child: searchResult != null
                      ? setUpButtonWithResults(searchResult)
                      : setUpButtonWithNoResults()),
            ],
          ),
        ),
      ),
    );
  }

  Container setUpButtonWithResults(DestinationSearchResult searchResult) {
    return Container(
      margin: searchResult.results.length == 0
          ? EdgeInsets.only(top: 270.0, right: 24.0, left: 170.0)
          : EdgeInsets.only(top: 448.0, right: 24.0, left: 170.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getContinueButtonText(),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400)),
              Icon(Icons.chevron_right),
            ],
          ),
          color: Colors.pinkAccent,
          textColor: Colors.white,
          elevation: 4,
          onPressed: () {
            // this is where you handle the capturing of the address
            //use address in the next page
            // if home was click save address then move on to next page
          },
        ),
      ),
    );
  }

  Container setUpButtonWithNoResults() {
    return Container(
      margin: EdgeInsets.only(top: 270.0, right: 24.0, left: 170.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text( getContinueButtonText(),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400)),
              Icon(Icons.chevron_right),
            ],
          ),
          color: Colors.pinkAccent,
          textColor: Colors.white,
          elevation: 4,
          onPressed: () {
            // this is where you handle the capturing of the address
            //use address in the next page
            // if home was click save address then move on to next page
          },
        ),
      ),
    );
  }

  void getLocationResults(String searchText) async {
    _bloc.searchPlacesByQuery(searchText, userPosition);
  }

  Flexible buildSuggestionList(DestinationSearchResult searchResult) {
    return Flexible(
      child: Visibility(
        visible: searchResult.results.length == 0 ? false : true,
        child: Card(
          margin: const EdgeInsets.only(
              top: 250.0, right: 28.0, left: 28.0, bottom: 244.0),
          color: Colors.white,
          elevation: 8,
          child: Container(
            child: ListView.builder(
              itemCount: searchResult.results.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                child: createSuggestionItemView(context, index, searchResult),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                  final placeDetails = await _bloc
                      .getPlaceDetails(searchResult.results[index].placeId);
                  final latitude = placeDetails.geometry.location.lat;
                  final longitude = placeDetails.geometry.location.lng;
                  final address = placeDetails.formattedAddress;
                  _locationBloc.setHomeLocation(address, latitude, longitude);
                  Navigator.pushNamed(context, 'map/$latitude,$longitude');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createSuggestionItemView(
      BuildContext context, int index, DestinationSearchResult searchResult) {
    var placeSuggestion = searchResult.results[index];
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                      placeSuggestion.streetAddress +
                          ", ${placeSuggestion.location}",
                      style: TextStyle(fontSize: 12.0))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getAppBarTitle() {
    return "Where to exactly ?";
  }

  String getContinueButtonText() {
    return "Set Home and Go";
  }

  String getHintText() {
    return "Enter your destination address here...";
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfigHelper = Provider.of<RemoteConfigHelper>(context);
    _bloc = DestinationSearchBloc(
        DestinationSearchRepository(GoogleApiService(remoteConfigHelper)));
    return StreamBuilder<DestinationSearchResult>(
        stream: _bloc.getPlaceSuggestionObservable(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          DestinationSearchResult result = snapshot.data;
          return buildContentView(result);
        });
  }
}
