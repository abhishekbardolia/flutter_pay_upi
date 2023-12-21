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
    case "initiateTransaction":
      let uri = (call.arguments! as AnyObject)["uri"]! as? String
      result(launchUri(uri: uri!, result: result))
    case "navigateToAppstore":
      let uri = (call.arguments! as AnyObject)["uri"]! as? String
      result(launchUri(uri: uri!, result: result))
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
private func canLaunch(uri: String) -> Bool {
   let url = URL(string: uri)
   return UIApplication.shared.canOpenURL(url!)
 }

//private func canLaunch(uri: String) -> Bool {
//
////    let arr = uri.components(separatedBy: "://")
//
////    if let appName = arr.first {
////
////        //            if let url = URL(string: appName + "://") {
////        //                return UIApplication.shared.canOpenURL( URL(string: uri)!)
////        //            }
////
////        //            if isAppInstalled(urlScheme: "phonepe://") {
////        //                        print("PhonePe is installed!")
////        //                    } else {
////        //                        print("PhonePe is not installed.")
////        //                    }
////        //
////        //        }
////        //        return false
////
////
////        if isAppInstalled(urlScheme: "https://www.phonepe.com/") {
////            print("PhonePe or browser is available!")
////        } else {
////            print("PhonePe or browser is not available.")
////        }
////
////        //       let url = URL(string: uri)
////        //       return UIApplication.shared.canOpenURL(url!)
////    }
//    if isAppInstalled(urlScheme: "https://www.phonepe.com/") {
//        print("PhonePe or browser is available!")
//    } else {
//        print("PhonePe or browser is not available.")
//    }
//    //       let url = URL(string: uri)
//    //       return UIApplication.shared.canOpenURL(url!)
//    return false;
//}

    func isAppInstalled(urlScheme: String) -> Bool {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            return true
        } else {
            return false
        }
    }

    func launchUri(uri: String, result: @escaping FlutterResult) -> Bool {
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

