import 'package:flutter/material.dart';

class RidePartyDropDown extends StatefulWidget {
  RidePartyDropDown({Key key}) : super(key: key);

  @override
  _RidePartyDropDownState createState() => new _RidePartyDropDownState();
}

class _RidePartyDropDownState extends State<RidePartyDropDown> {

  List numberOfHumans =
  ["1", "2", "3", "4", "5","6","7","8"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentNumberOfHumans;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentNumberOfHumans = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String individual in numberOfHumans) {
      items.add(new DropdownMenuItem(
          value: individual,
          child: new Text(individual)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(16.0),
              ),
              new DropdownButton(
                value: _currentNumberOfHumans,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,
              )
            ],
          )
      ),
    );
  }

  void changedDropDownItem(String selectedNumberOfHumans) {
    setState(() {
      _currentNumberOfHumans = selectedNumberOfHumans;
    });
  }
}