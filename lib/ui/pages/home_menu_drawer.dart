import 'package:flutter/material.dart';
import 'package:gmoh_app/io/database/location_database.dart';
import 'package:gmoh_app/io/models/location_model.dart';
import 'package:gmoh_app/io/repository/location_repo.dart';
import 'package:gmoh_app/ui/blocs/destination_search_bloc.dart';
import 'package:gmoh_app/ui/blocs/drawer_bloc.dart';
import 'package:gmoh_app/ui/models/locator_page_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rxdart/subjects.dart';

class HomeMenuDrawer extends StatefulWidget {
  const HomeMenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  TextEditingController _controller;

  final onTextChangedListener = new PublishSubject<String>();
  DrawerBloc _drawerBloc;

  @override
  void initState() {
    super.initState();
    var locationDatabase = LocationDatabase();
    _drawerBloc = DrawerBloc(LocationRepository(locationDatabase));
    _controller = new TextEditingController(text: '');
    var txt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var txt = TextEditingController();
    return StreamBuilder<String>(
        stream: _drawerBloc.getAddressAsObservable(),
        builder: (context, snapshot) {
          var address = snapshot.data;
          return Drawer(
            child: Container(
              color: Hexcolor("#2B2C2C"),
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                      child: Row(
                    children: [
                      Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3,
                            color: Colors.pinkAccent),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/profileImage.jpg'),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Im a Rida",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Center(
                        child:
                            Text(address != null ? address : "No Home Address Set")),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, right: 15.0, left: 15.0, bottom: 10.0),
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Edit Address'),
                      color: Colors.pinkAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context,
                            'locator_page/${getStringFromEnum(LocationPageMode.HOME_LOCATION)}');
                      },
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, right: 0.0, left: 0.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pinkAccent,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.only(
                          top: 10.0, right: 0.0, left: 0.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.pinkAccent,
                      ),
                      child: SizedBox(
                        height: 50,
                        child: Center(child: Text("Help", style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
