import 'package:flutter/material.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';
import 'package:gmoh_app/ui/pages/action_selection_view.dart';
import 'package:gmoh_app/util/connectivity_service.dart';
import 'package:gmoh_app/util/connectivity_status.dart';
import 'package:gmoh_app/util/remote_config_helper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (_) => RemoteConfigHelper.getInstance()),
        StreamProvider<ConnectivityStatus>(
            create: (_) =>
                ConnectivityService().connectionStatusController.stream),
      ],child:MaterialApp(
        title: 'Flutter Demo',
        initialRoute: 'action_selection',
        onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => ActionSelectionPage()),
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: Colors.blue,
        )),
    );
  }
}
