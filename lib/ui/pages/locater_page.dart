import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/ui/models/locator_page_model.dart';
import 'package:gmoh_app/util/permissions_helper.dart';
import 'package:gmoh_app/util/titled_divider.dart';
import 'package:rxdart/subjects.dart';

class LocatorPage extends StatefulWidget {
  static const String routeName = "/locatorPage";
  final String _pageModeValue;
  LocatorPage(this._pageModeValue);

  _LocatorPageState createState() => _LocatorPageState(getPageModeFromString(_pageModeValue));
}

class _LocatorPageState extends State<LocatorPage>
    implements PermissionDialogListener {
  _LocatorPageState(this._locationPageMode);

  DestinationSearchBloc bloc =
      DestinationSearchBloc(DestinationSearchRepository(GoogleApiService()));

  var hasRequestedLocationPermission = false;
  final onTextChangedListener = new PublishSubject<String>();
  final permissionsHelper = new PermissionsHelper();
  Position userPosition;

  final LocationPageMode _locationPageMode;

  @override
  void initState() {
    onTextChangedListener
        .distinct()
        .debounceTime(Duration(milliseconds: 400))
        .listen((searchText) {
      getLocationResults(searchText);
    });
    attemptToRetrieveUserPosition();
    super.initState();
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
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userPosition = position;
      });
    }
  }

  void requestLocationPermission() async {
    if (await permissionsHelper.requestLocationPermission()) {
      setState(() {
        hasRequestedLocationPermission = true;
      });
    } else {
      permissionsHelper.onLocationPermissionDenied(context, this);
    }
  }

  Scaffold buildContentView(DestinationSearchResult searchResult) {
    return Scaffold(
      appBar: AppBar(
        title: getAppBarTitle(),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: getHintText()),
                onChanged: (searchText) {
                  onTextChangedListener.add(searchText);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new TitledDivider("Suggestions"),
            ),
            searchResult != null
                ? buildSuggestionList(searchResult)
                : Container()
          ],
        ),
      ),
    );
  }

  String getHintText() {
    switch (_locationPageMode) {
      case LocationPageMode.HOME_LOCATION:
        return "Enter your Home Address...";
      case LocationPageMode.NEW_LOCATION:
        return "Enter your Destination Address";
      case LocationPageMode.ORIGIN:
        return "Enter where you want to be picked up from";
      default:
        return "Enter an Address";
    }
  }

  Expanded buildSuggestionList(DestinationSearchResult searchResult) {
    return Expanded(
        child: ListView.builder(
      itemCount: searchResult.results.length,
      itemBuilder: (BuildContext context, int index) =>
          createSuggestionItemView(context, index, searchResult),
    ));
  }

  void getLocationResults(String searchText) async {
    setState(() {
      bloc.searchPlacesByQuery(searchText, userPosition);
    });
  }

  Widget createSuggestionItemView(
      BuildContext context, int index, DestinationSearchResult searchResult) {
    var placeSuggestion = searchResult.results[index];
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(placeSuggestion.streetAddress,
                          style: TextStyle(fontSize: 18.0))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("${placeSuggestion.location}",
                          style: TextStyle(fontSize: 12.0))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text getAppBarTitle() {
    switch (_locationPageMode) {
      case LocationPageMode.HOME_LOCATION:
        return Text("Where's Home?");
      case LocationPageMode.NEW_LOCATION:
        return Text("Where to exactly?");
      case LocationPageMode.ORIGIN:
        return Text("Enter a starting point?");
      default:
        return Text("Enter a starting point?");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.placeSuggestionObservable.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          DestinationSearchResult result = snapshot.data;
          return buildContentView(result);
        });
  }
}
