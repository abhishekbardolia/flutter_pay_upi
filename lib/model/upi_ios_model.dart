import '../utils/enum.dart';

class UPIIOSModel {
  String? appName;
  String? appIcon;
  String? freechargeTransactionIDFromApp;
  IOSUPIPaymentApps? appOptionEnum;

  UPIIOSModel(
      {this.appName,
        this.appIcon,
        this.freechargeTransactionIDFromApp,
        this.appOptionEnum});
}
