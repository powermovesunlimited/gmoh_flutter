import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigHelper {
  static const String _GOOGLE_API_KEY = "google_api_key";

  final RemoteConfig _remoteConfig;

  static RemoteConfigHelper _instance;

  RemoteConfigHelper({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  static Future<RemoteConfigHelper> getInstance() async {
    if(_instance == null) {
      _instance = RemoteConfigHelper(
        remoteConfig: await createRemoteConfig()
      );
    }
    return _instance;
  }

  static Future<RemoteConfig> createRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(
        RemoteConfigSettings(debugMode: !kReleaseMode));
    await remoteConfig.setDefaults(<String, dynamic>{
      'google_api_key': 'test_key_dummy',
    });
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
    return remoteConfig;
  }

  String get googleApiKey => _remoteConfig.getString(_GOOGLE_API_KEY);
}