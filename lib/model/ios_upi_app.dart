
import 'package:flutter_pay_upi/model/upi_ios_model.dart';

import '../utils/enum.dart';

final List<UPIIOSModel> iosUPIApps = [
  UPIIOSModel(
      appName: 'Amazon Pay',
      appIcon: 'assets/amazon_pay.png',
      freechargeTransactionIDFromApp: "Amazon Pay",
      appOptionEnum: IOSUPIPaymentApps.amazonpay),
  UPIIOSModel(
      appName: 'BHIMUPI',
      appIcon: 'assets/bhim_logo.png',
      freechargeTransactionIDFromApp: "Bhim",
      appOptionEnum: IOSUPIPaymentApps.bhimupi),
  UPIIOSModel(
      appName: 'Google Pay',
      appIcon: "assets/gpay_logo.png",
      freechargeTransactionIDFromApp: "Google Pay",
      appOptionEnum: IOSUPIPaymentApps.googlepay),
  UPIIOSModel(
      appName: 'Paytm',
      appIcon: "assets/paytm_logo.png",
      freechargeTransactionIDFromApp: "Paytm",
      appOptionEnum: IOSUPIPaymentApps.paytm),
  UPIIOSModel(
      appName: 'PhonePe',
      appIcon: "assets/phone_pe.png",
      freechargeTransactionIDFromApp: "PhonePe",
      appOptionEnum: IOSUPIPaymentApps.phonepe),
];
