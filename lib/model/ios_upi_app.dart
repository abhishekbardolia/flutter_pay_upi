import 'package:flutter_pay_upi/model/upi_ios_model.dart';

/// List of pre-defined UPI apps for iOS.
///
/// This list includes instances of [UpiIosModel] representing UPI apps commonly
/// used on iOS devices. Each instance contains information such as the app name
/// and the corresponding app icon image asset.
final List<UpiIosModel> iosUPIApps = [
  UpiIosModel(
    appName: 'Amazon Pay',
    appIcon: 'images/amazon_pay.png',
  ),
  UpiIosModel(
    appName: 'BhimUpi',
    appIcon: 'images/bhim_logo.png',
  ),
  UpiIosModel(
    appName: 'Google Pay',
    appIcon: "images/gpay_logo.png",
  ),
  UpiIosModel(
    appName: 'Paytm',
    appIcon: "images/paytm_logo.png",
  ),
  UpiIosModel(
    appName: 'PhonePe',
    appIcon: "images/phone_pe.png",
  ),
];
