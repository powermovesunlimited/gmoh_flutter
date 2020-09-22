import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/ui/models/route_data.dart';
import 'package:gmoh_app/ui/models/route_intent.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/locator/alt_location_page.dart';
import 'package:gmoh_app/ui/pages/locator/home_locator_page.dart';
import 'package:gmoh_app/ui/pages/trip_confirmation_map.dart';
import 'package:gmoh_app/util/connectivity_status.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

abstract class LocatorPage extends StatefulWidget {
  final RouteData routeData;
  final RouteIntent routeIntent;

  LocatorPage(this.routeData, this.routeIntent);

  LocatorPageState createState();
}

abstract class LocatorPageState extends State<LocatorPage> {
  Position userPosition;

  LocatorPageState(this.routeData);

  DestinationSearchBloc _bloc;

  final onTextChangedListener = new PublishSubject<String>();

  var _textController = new TextEditingController();
  final RouteData routeData;

  @override
  void initState() {
    onTextChangedListener.distinct().listen((searchText) {
      getLocationResults(searchText);
    });
    super.initState();
  }

  bool isInternetConnectivityAvailable;

  void getNetworkConnectivity() {
    final connectionStatus = Provider.of<ConnectivityStatus>(context, listen: false);
    if (connectionStatus == ConnectivityStatus.Cellular ||
        connectionStatus == ConnectivityStatus.WiFi) {
      isInternetConnectivityAvailable = true;
    } else {
      isInternetConnectivityAvailable = false;
    }
  }

  void showNoConnectivityDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("You are offline. \n"
              "Please enable Mobile Data or Wifi inorder to use this application"),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                AppSettings.openDataRoamingSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  Widget buildContentView(DestinationSearchResult searchResult) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActionSelectionPage(),
            ));
        return true;
      },
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background1300.png"),
                fit: BoxFit.fill),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Exit'),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActionSelectionPage()));
                },
              ),
              elevation: 0,
            ),
            body: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [HexColor("#078B91"), HexColor("#336D6B")]),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 96,
                    child: Center(
                      child: Text(
                        getAppBarTitle(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  margin: const EdgeInsets.only(
                      top: 18.0, right: 24.0, left: 24.0),
                  child: Container(
                    transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                    child: TextField(
                      controller: _textController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: Container(
                          transform:
                              Matrix4.translationValues(10.0, 0.0, 0.0),
                          child: Icon(
                            Icons.search,
                            size: 24,
                            color: HexColor("#078B91"),
                          ),
                        ),
                        hintText: getHintText(),
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                      onChanged: (searchText) {
                        onTextChangedListener.add(searchText);
                      },
                    ),
                  ),
                ),
                Container(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    child: searchResult != null
                        ? buildSuggestionList(searchResult)
                        : Container()),
                setupContinueButton(searchResult),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Flex setupContinueButton(DestinationSearchResult searchResult) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 8.0, right: 24.0),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 200,
                height: 40,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(getContinueButtonText(),
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400)),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                      ),
                    ],
                  ),
                  color: Colors.pinkAccent,
                  textColor: Colors.white,
                  elevation: 4,
                  onPressed: () {
                    navigateToNextPage();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getLocationResults(String searchText) async {
    _bloc.searchPlacesByQuery(searchText, userPosition);
  }

  Flex buildSuggestionList(DestinationSearchResult searchResult) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Visibility(
            visible: searchResult.results.length == 0 ? false : true,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              margin: const EdgeInsets.only(right: 24.0, left: 24.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchResult.results.length,
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  child: createSuggestionItemView(context, index, searchResult),
                  onTap: () async {
                    final placeDetails = await _bloc
                        .getPlaceDetails(searchResult.results[index].placeId);
                    final latitude = placeDetails.geometry.location.lat;
                    final longitude = placeDetails.geometry.location.lng;
                    final address = placeDetails.formattedAddress;

                    FocusScope.of(context).unfocus();
                    setState(() {
                      var latLng = LatLng(latitude, longitude);
                      routeData.destination = latLng;
                      _textController.text = placeDetails.formattedAddress;
                      searchResult.results.clear();
                      onAddressSelected(address, latLng);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget createSuggestionItemView(
      BuildContext context, int index, DestinationSearchResult searchResult) {
    var placeSuggestion = searchResult.results[index];
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                placeSuggestion.streetAddress + ", ${placeSuggestion.location}",
                style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );
  }

  String getAppBarTitle() {
    var text;
    text = "Where to exactly ?" !=null;
    return text;
  }

  String getContinueButtonText() {
    var text;
    text = "Set Home and Go" !=null;
    return text;
  }

  String getHintText() {
    var text;
    text = "Enter your destination address here..." !=null;
    return text;
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

  void navigateToNextPage() {
    getNetworkConnectivity();
    final intent = widget.routeIntent;
    print("this is the locator page intent $intent");

    if (intent is GoHome) {
      if (routeData.origin != null && routeData.destination != null) {
        //go to map
        goForwardToMapFromHome(){
          return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TripConfirmationMap(routeData.origin, routeData.destination, intent),
              ));
        }
        isInternetConnectivityAvailable? goForwardToMapFromHome(): showNoConnectivityDialog();
      } else if (routeData.destination == null) {
        //go to get home location

        goBackToHomeLocator(){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeLocatorPage(routeData, GoBackToHomeLocatorPage()),
              ));
        }
        isInternetConnectivityAvailable? goBackToHomeLocator(): showNoConnectivityDialog();
      }
    } else if (intent is GoSomewhereElse){
      if (routeData.destination != null) {
        // go to map
        goForwardToMap(){
          return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TripConfirmationMap(routeData.origin, routeData.destination, GoBackSomewhereElsePage()),
              ));
        }
        isInternetConnectivityAvailable? goForwardToMap(): showNoConnectivityDialog();
      } else {
        //go to get alt location

        goBackToAltLocation(){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlternateLocationPage(routeData, intent),
              ));
        }
        isInternetConnectivityAvailable? goBackToAltLocation(): showNoConnectivityDialog();

      }
    } else if (intent is GoHomePage) {
      if (routeData.destination != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ActionSelectionPage(),
            ));

      }
    } else if (intent is GoBackToHomeLocatorPage){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TripConfirmationMap(routeData.origin, routeData.destination, GoBackToHomeLocatorPage()),
          ));
    } else if (intent is GoBackSomewhereElsePage){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TripConfirmationMap(routeData.origin, routeData.destination, GoBackSomewhereElsePage()),
          ));
    }
  }

  onAddressSelected(String address, LatLng latLng);
}
