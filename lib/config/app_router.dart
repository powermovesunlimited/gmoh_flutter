import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';

class AppRouter {
  static Router appRouter = Router();
  static Handler _actionSelectionHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ActionSelectionPage());

  static void setupRouter() {
    appRouter.define('action_selection', handler: _actionSelectionHandler);
  }
}
