import 'package:flutter/material.dart';

class AddresserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text('Where do you\nwanna go?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
               fontSize: 32,
               fontFamily: 'RobotoBold'),
               ),
          )
        )
      ],
    );
  }
}
