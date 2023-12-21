import 'package:flutter/services.dart';

import '../model/ios_upi_app.dart';
import '../model/upi_ios_model.dart';
import 'flutter_native_upi.dart';
import '../model/upi_app_model.dart';

abstract class GetUpiApps {
  Future<List<UpiApp>> getUpiApps();
}
abstract class GetIosUpiApps {
  Future<List<UpiIosModel>> getUpiApps();
}

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

class GetUpiAppsiOS implements GetIosUpiApps {
  @override
  Future<List<UpiIosModel>> getUpiApps() async {
    List<UpiIosModel> upiList=iosUPIApps;
    return upiList;
  }
}
