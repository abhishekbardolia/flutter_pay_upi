import 'package:flutter/services.dart';

import '../model/ios_upi_app.dart';
import '../model/upi_ios_model.dart';
import 'flutter_native_upi.dart';
import '../model/upi_app_model.dart';

/// Abstract class defining the contract for fetching UPI (Unified Payments Interface) apps.
///
/// Subclasses must implement the [getUpiApps] method to provide the list of UPI apps.
abstract class GetUpiApps {
  /// Fetches the list of UPI apps.
  ///
  /// Returns:
  /// A [Future] containing a list of [UpiApp] instances representing UPI apps.
  Future<List<UpiApp>> getUpiApps();
}

/// Abstract class defining the contract for fetching UPI apps specific to iOS.
///
/// Subclasses must implement the [getUpiApps] method to provide the list of iOS-specific UPI apps.
abstract class GetIosUpiApps {
  /// Fetches the list of iOS-specific UPI apps.
  ///
  /// Returns:
  /// A [Future] containing a list of [UpiIosModel] instances representing iOS UPI apps.
  Future<List<UpiIosModel>> getUpiApps();
}

/// Concrete implementation of [GetUpiApps] for Android platform.
///
/// This class fetches the list of UPI apps available on Android devices using the native platform channel.
class GetUpiAppsAndroid extends GetUpiApps {
  @override
  Future<List<UpiApp>> getUpiApps() async {
    List<UpiApp>? upiList =
        await FlutterNativeUpi(const MethodChannel('flutter_pay_upi'))
            .getAllUpiApps();
    if (upiList.isNotEmpty) {
      return upiList;
    }
    return [];
  }
}

/// Concrete implementation of [GetIosUpiApps] for iOS platform.
///
/// This class returns a pre-defined list of iOS-specific UPI apps.
class GetUpiAppsiOS implements GetIosUpiApps {
  @override
  Future<List<UpiIosModel>> getUpiApps() async {
    List<UpiIosModel> upiList = iosUPIApps;
    return upiList;
  }
}
