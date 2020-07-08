import 'package:flutter/material.dart';
import 'package:gmoh_app/config/app_router.dart';

void main() {
  AppRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        initialRoute: 'action_selection',
        onGenerateRoute: AppRouter.router.generator,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ));
  }
}
