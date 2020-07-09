import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmoh_app/io/models/home_location_result.dart';
import 'package:gmoh_app/ui/models/locator_page_model.dart';

class ActionSelectionView extends StatelessWidget {
  final HomeLocationResult homeLocationResult;

  ActionSelectionView(this.homeLocationResult);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background1300.png"),
            fit: BoxFit.fill),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 72.0, right: 24.0, left: 24.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text('Where are you going?',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700)),
                color: Colors.teal.shade400,
                textColor: Colors.white,
                elevation: 4,
                onPressed: () {},
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 34.0, right: 24.0, left: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage("assets/images/homeIcon.png"),
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Text('Home',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                color: Colors.pinkAccent,
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
                    Navigator.pushNamed(context,
                        'locator_page/${getStringFromEnum(LocationPageMode.HOME_LOCATION)}');
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Somewhere Else',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700)),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                color: Colors.pinkAccent,
                textColor: Colors.white,
                elevation: 4,
                onPressed: () {
                  var newLocation =
                      getStringFromEnum(LocationPageMode.NEW_LOCATION);
                  Navigator.pushNamed(context, 'locator_page/${newLocation}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
