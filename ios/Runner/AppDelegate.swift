import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.example.app/db",
                                                      binaryMessenger: controller.binaryMessenger)

      channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "incrementValue" {
              do {
                  try DatabaseHelper.shared.incrementValue()
                  result("Value incremented")
              } catch {
                  result(FlutterError(code: "UNAVAILABLE",
                                            message: "Increment failed",
                                            details: nil))
                  }
              }
          }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func applicationWillTerminate(_ application: UIApplication) {
    do {
      try DatabaseHelper.shared.incrementValue()
    } catch {
      print("Failed to increment value on termination: \(error)")
    }
  }
}
