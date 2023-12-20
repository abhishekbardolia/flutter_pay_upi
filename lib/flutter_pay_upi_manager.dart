import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pay_upi/service/flutter_native_upi.dart';
import 'package:flutter_pay_upi/service/get_upi_app_list.dart';
import 'package:flutter_pay_upi/utils/exception.dart';

import 'model/request_parameters.dart';
import 'model/upi_app_model.dart';
import 'model/upi_response.dart';

class FlutterPayUpiManager {
  static Future<List<UpiApp>> getListOfAndroidUpiApps() async {
      return await GetUpiAppsAndroid().getUpiApps();
  }
  static Future<List<UpiApp>> getListOfAndroidUpiApps() async {
      return await GetUpiAppsIos().getUpiApps();
  }

  static void startPayment({
    required String paymentApp,
    required String payeeVpa,
    required String payeeName,
    required String transactionId,
    String? transactionRefId,
    required String payeeMerchantCode,
    required String description,
    required String amount,
    String? currency,
    required Function(UpiResponse) response,
    required Function(String) error,
  }) async {
    UPIRequestParameters upiRequestParams =
        UPIRequestParameters.builder((upiRequestBuilder) {
      upiRequestBuilder
        ..setPaymentApp(paymentApp)
        ..setPayeeVpa(payeeVpa)
        ..setPayeeName(payeeName)
        ..setPayeeMerchantCode(payeeMerchantCode)
        ..setTransactionId(transactionId)
        ..setTransactionRefId(transactionRefId ?? transactionId)
        ..setDescription(description.isNotEmpty ? description : transactionId)
        ..setAmount(amount)
        ..setCurrency(currency ?? "INR");
    });
    try {
      UpiResponse upiInstance =
          await FlutterNativeUpi(const MethodChannel('flutter_pay_upi'))
              .initiateTransaction(upiRequestParams);
      response(upiInstance);
      // _showTransactionDetailsDialog(upiInstance);
    } on PlatformException catch (e) {
      error(e.message.toString());
    } catch (e) {
      if (e is UpiException) {
        // _showRoundedDialog(context,e.message);
        error(e.message.toString());
      } else {
        error(e.toString());
      }
    }
  }
}
