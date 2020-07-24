import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
        GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyA8evr0OoV_qzALJO11xUenbl3JGRMGQMc")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
