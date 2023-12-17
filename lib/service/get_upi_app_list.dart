import 'package:flutter/services.dart';

import 'flutter_native_upi.dart';
import '../model/upi_app_model.dart';

abstract class GetUpiApps {
  Future<List<UpiApp>> getUpiApps();
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

class GetUpiAppsiOS implements GetUpiApps {
  @override
  Future<List<UpiApp>> getUpiApps() async {
    return [];
  }
}


