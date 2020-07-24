import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/ride_party_dialog.dart';
import 'package:hexcolor/hexcolor.dart';

class FindYourRideLoadingPage extends StatelessWidget {
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
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Hexcolor("#de5d54"),),
              child: Column(
                children: [
                  Container(
                    child: Center(
                      heightFactor: 4,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          child: Column(
                            children: [
                              Text('Finding your ride...',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: SizedBox(
                                  height: 2, width: 160, child: Container(child: LinearProgressIndicator(backgroundColor: Hexcolor("#de5d54"), valueColor: AlwaysStoppedAnimation(Colors.white) , ))
                                  ,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}


