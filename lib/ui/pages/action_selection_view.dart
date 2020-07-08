import 'package:flutter/material.dart';
import 'package:gmoh_app/io/models/home_location_result.dart';
import 'package:gmoh_app/ui/models/locator_page_model.dart';

class ActionSelectionView extends StatelessWidget {
  final HomeLocationResult homeLocationResult;
  ActionSelectionView(this.homeLocationResult);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Center(
            child: Text(
              'Where do you\nwanna go?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 72.0, right: 24.0, left: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: MaterialButton(
              child: Text('Home',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700)),
              color: Colors.cyan,
              textColor: Colors.white,
              elevation: 4,
              onPressed: () {
                if (homeLocationResult is HomeLocationSet) {
                  final noticeText = new Text(
                      "Location: Lat=${(homeLocationResult as HomeLocationSet).location.latitude} Lng=${(homeLocationResult as HomeLocationSet).location.longitude}");
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: noticeText,
                  ));
                } else if (homeLocationResult is HomeLocationNotSet) {
                  Navigator.pushNamed(context, 'locator_page/${getStringFromEnum(LocationPageMode.HOME_LOCATION)}');
                }

              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: MaterialButton(
              child: Text('Somewhere Else',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700)),
              color: Colors.deepPurple,
              textColor: Colors.white,
              elevation: 4,
              onPressed: () {
                var newLocation = getStringFromEnum(LocationPageMode.NEW_LOCATION);
                Navigator.pushNamed(context, 'locator_page/${newLocation}');
              },
            ),
          ),
        ),
      ],
    );
  }
}
