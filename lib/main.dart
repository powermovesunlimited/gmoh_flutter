import 'package:flutter/material.dart';
import 'package:gmoh_app/config/app_router.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:provider/provider.dart';

void main() {
  AppRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        FutureProvider(create: (_) => RemoteConfigHelper.getInstance()),
      ],child:MaterialApp(
        title: 'Flutter Demo',
        initialRoute: 'action_selection',
        onGenerateRoute: AppRouter.router.generator,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
        )),
    );
  }
}
