import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';


class AddresserPage extends StatelessWidget {
  LocationDatabase database;
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
              onPressed: () {},
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
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
