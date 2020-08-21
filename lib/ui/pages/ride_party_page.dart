import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/select_your_rideshare_page.dart';
import 'package:gmoh_app/util/hex_color.dart';
import 'package:gmoh_app/util/rides_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RidePartyPage extends StatelessWidget {

  final LatLng origin;
  final LatLng destination;

  const RidePartyPage( this.origin, this.destination);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
        "Exit",
        textAlign: TextAlign.center,
      )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background1300.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 0.0, right: 24.0, left: 24.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: HexColor("#078B91"),),
              child: SizedBox(
                width: double.infinity,
                height: 120,
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Center(
                    child: Text('How many people are riding?',
                      style: TextStyle(color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: FractionalOffset.center,
                  margin: EdgeInsets.only(top: 20.0, right: 24.0, left: 24.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0, right: 10.0, left: 0.0),
                          child: SizedBox(
                            height: 100,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text('1 -3',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400)),
                              color: Colors.pinkAccent,
                              textColor: Colors.white,
                              elevation: 4,
                              onPressed: () {
                                //todo
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0, right: 0.0, left: 10.0),
                          child: SizedBox(
                            height: 100,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text('4 +',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400)),
                              color: Colors.pinkAccent,
                              textColor: Colors.white,
                              elevation: 4,
                              onPressed: () {
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: FractionalOffset.center,
                  margin: EdgeInsets.only(top: 20.0, right: 24.0, left: 24.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Find my ride',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400)),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                      color: Colors.pinkAccent,
                      textColor: Colors.white,
                      elevation: 4,
                      onPressed: () {
                        final rideShareRides = RidesList().rides;
                        print("Ride map data $origin,$destination");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectRideSharePage(origin, destination, rideShareRides),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
