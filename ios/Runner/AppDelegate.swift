import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    RemoteConfig.remoteConfig().fetchAndActivate() { status, error in
          let apiKey : String = RemoteConfig.remoteConfig()["google_api_key"].stringValue ?? "MISSING";
          // os_log("Google_Maps_SDK_for_iOS_API_KEY = '%@'", apiKey)
          GMSServices.provideAPIKey(apiKey)
        }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
