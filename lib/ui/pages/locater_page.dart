import 'package:flutter/material.dart';
import 'package:gmoh_app/io/apis/google_api_services.dart';
import 'package:gmoh_app/io/repository/destinations_search_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/util/titled_divider.dart';
import 'package:rxdart/subjects.dart';

class LocatorPage extends StatefulWidget {
  static const String routeName = "/locatorPage";
  final bool _isGoingHome;

  LocatorPage(this._isGoingHome);

  _LocatorPageState createState() => _LocatorPageState(_isGoingHome);
}

class _LocatorPageState extends State<LocatorPage> {
  final bool _isGoingHome;
  final onTextChangedListener = new PublishSubject<String>();

  DestinationSearchBloc bloc =
      DestinationSearchBloc(DestinationSearchRepository(GoogleApiService()));
  _LocatorPageState(this._isGoingHome);

  @override
  void initState() {
    onTextChangedListener
        .distinct()
        .debounceTime(Duration(milliseconds: 400))
        .listen((searchText) {
      getLocationResults(searchText);
    });
    super.initState();
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
    if (_isGoingHome) {
      return "Enter your Home Address...";
    } else {
      return "Enter your Destination Address";
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
      bloc.searchPlacesByQuery(searchText);
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
    if (_isGoingHome) {
      return Text("Where's Home?");
    } else {
      return Text("Where to exactly?");
    }
  }
}
