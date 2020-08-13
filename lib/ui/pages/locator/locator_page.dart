import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

abstract class LocatorPage extends StatefulWidget {

  LocatorPage();

  LocatorPageState createState();
}

class LocatorPageState extends State<LocatorPage> {

  Position userPosition;

  LocatorPageState();

  DestinationSearchBloc _bloc;

  var _addressEntered = Set();

  final onTextChangedListener = new PublishSubject<String>();

  var _textController = new TextEditingController();

  @override
  void initState() {
    onTextChangedListener.distinct().listen((searchText) {
      getLocationResults(searchText);
    });
    super.initState();
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
                  child: Container(
                    transform: Matrix4.translationValues(-18.0, 0.0, 0.0),
                    child: TextField(
                      controller: _textController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          transform: Matrix4.translationValues(10.0, 0.0, 0.0),
                          child: Icon(
                            Icons.search,
                            size: 24,
                            color: HexColor("#078B91"),
                          ),
                        ),
                        hintText: getHintText(),
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
              ),
              Container(
                  child: searchResult == null
                      ? setUpButtonWithNoResults()
                      : setUpButtonWithResults(searchResult)),
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
              itemBuilder: (BuildContext context, int index) =>
                  GestureDetector(
                    child: createSuggestionItemView(
                        context, index, searchResult),
                    onTap: () async {
                      final placeDetails = await _bloc
                          .getPlaceDetails(searchResult.results[index].placeId);
                      final latitude = placeDetails.geometry.location.lat;
                      final longitude = placeDetails.geometry.location.lng;
                      final address = placeDetails.formattedAddress;
                      _addressEntered.add(address);
                      _addressEntered.add(latitude);
                      _addressEntered.add(longitude);
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _textController.text = placeDetails.formattedAddress;
                        searchResult.results.clear();
                      });
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createSuggestionItemView(BuildContext context, int index,
      DestinationSearchResult searchResult) {
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
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400))
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

  void navigateToNextPage() {
    // placeholder function for navigation to next page
  }

  Set userEnteredAddress() {
    return _addressEntered;
  }

}
