import Flutter
import UIKit

public class FlutterPayUpiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pay_upi", binaryMessenger: registrar.messenger())
    let instance = FlutterPayUpiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "launch":
      let uri = (call.arguments! as AnyObject)["uri"]! as? String
      result(self.launchUri(uri: uri!, result: result))
    default:``
      result(FlutterMethodNotImplemented)
    }
  }
}


    private func canLaunch(uri: String) -> Bool {
       let url = URL(string: uri)
       return UIApplication.shared.canOpenURL(url!)
     }

    private func launchUri(uri: String, result: @escaping FlutterResult) -> Bool {
       if(canLaunch(uri: uri)) {
         let url = URL(string: uri)
         if #available(iOS 10, *) {
           UIApplication.shared.open(url!, completionHandler: { (ret) in
               result(ret)
           })
         } else {
           result(UIApplication.shared.openURL(url!))
         }
           return true
       }
       return false
     }