import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var lockViewController: UIViewController?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let lockChannel = FlutterMethodChannel(name: "com.example.detox_clone/lock",
                                               binaryMessenger: controller.binaryMessenger)

        lockChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "startLockTask" {
                self.startLockTask()
                result(nil)
            } else if call.method == "stopLockTask" {
                self.stopLockTask()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func startLockTask() {
        guard lockViewController == nil else { return } // Prevent multiple overlays

        lockViewController = UIViewController()
        lockViewController?.view.backgroundColor = UIColor.white

        let label = UILabel()
        label.text = "Device is Locked"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        lockViewController?.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: lockViewController!.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: lockViewController!.view.centerYAnchor)
        ])

        // Present the lock view controller as a full-screen overlay
        if let rootViewController = window?.rootViewController {
            rootViewController.present(lockViewController!, animated: true, completion: nil)
        }
    }

    private func stopLockTask() {
        lockViewController?.dismiss(animated: true, completion: nil)
        lockViewController = nil
    }
}
