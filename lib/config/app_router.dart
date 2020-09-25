import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/cupertino.dart';
import 'package:gmoh_app/ui/pages/action_selection_page.dart';

class AppRouter {
  static fluro.Router appRouter = fluro.Router();
  static fluro.Handler _actionSelectionHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ActionSelectionPage());

  static void setupRouter() {
    appRouter.define('action_selection', handler: _actionSelectionHandler);
  }
}
