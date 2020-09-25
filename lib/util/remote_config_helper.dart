import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigHelper {
  static const String _GOOGLE_API_KEY = "google_api_key";

  final RemoteConfig _remoteConfig;

  static bool isGoogleKeyRetrieved;

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
    try {
      await updateRemoteConfig(remoteConfig);
      isGoogleKeyRetrieved = true;
    } catch (e) {
      print("Error in Remote Config $e");
      isGoogleKeyRetrieved = false;
    }
    return remoteConfig;
  }

  static Future updateRemoteConfig(RemoteConfig remoteConfig) async {
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
  }

  String get googleApiKey => _remoteConfig.getString(_GOOGLE_API_KEY);
}