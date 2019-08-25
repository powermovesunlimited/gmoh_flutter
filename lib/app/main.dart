import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:gmoh_app/ui/pages/addresser_page.dart';
import 'package:gmoh_app/ui/pages/map.dart';
=======
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
>>>>>>> implement action selection page, add location bloc test

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Get Me Outta Here!",
              textAlign: TextAlign.center,
            ),
          ),
<<<<<<< HEAD
          body: MyAppState(),
=======
          body: ActionSelectionPage(),
>>>>>>> implement action selection page, add location bloc test
        ));
  }
}
