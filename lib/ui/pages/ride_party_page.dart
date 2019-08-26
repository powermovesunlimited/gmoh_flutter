import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/ride_party_dialog.dart';

class RidePartyPage extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Center(
            child: Text('Is this ride just for you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
               fontSize: 32,
               fontFamily: 'Roboto',
              fontWeight: FontWeight.w700), 
          ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 72.0, right: 24.0, left: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: MaterialButton(
              child: Text('Yes, Just Me',
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
              child: Text('No, I\u0027m with others',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700)),
              color: Colors.deepPurple,
              textColor: Colors.white,
              elevation: 4,
              onPressed: () {
                 showDialog(
                  context: context,
                  builder: (BuildContext context) => RidePartyDialog(
                  title: "How many?",
                  buttonText: "Okay",
                  ),
                );
              },
            ),
          ),
        ),
      ],
      
    );
  }
}