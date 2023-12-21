import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pay_upi/service/flutter_native_upi.dart';
import 'package:flutter_pay_upi/service/get_upi_app_list.dart';
import 'package:flutter_pay_upi/utils/exception.dart';

import 'model/request_parameters.dart';
import 'model/upi_app_model.dart';
import 'model/upi_ios_model.dart';
import 'model/upi_response.dart';

class FlutterPayUpiManager {
  static Future<List<UpiApp>> getListOfAndroidUpiApps() async {
    return await GetUpiAppsAndroid().getUpiApps();
  }

  static Future<List<UpiIosModel>> getListOfIosUpiApps() async {
    return await GetUpiAppsiOS().getUpiApps();
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
    required Function(UpiResponse, String) response,
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
      if (Platform.isAndroid) {
        UpiResponse upiInstance =
            await FlutterNativeUpi(const MethodChannel('flutter_pay_upi'))
                .initiateTransaction(upiRequestParams);
        response(upiInstance, amount);
        // _showTransactionDetailsDialog(upiInstance);
      } else {
        String url = appendAndMakeUrl(upiRequestParams);
        String response =
            await FlutterNativeUpi(const MethodChannel('flutter_pay_upi'))
                .initiateTransactioniOS(url);
        if (response == "Please install app!") {
          redirectToAppstore(paymentApp);
        }
      }
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

  static String appendAndMakeUrl(UPIRequestParameters upiRequestParams) {
    return "${getUpiAppSchema(upiRequestParams.paymentApp)}?pa=${upiRequestParams.payeeVpa}&pn=${upiRequestParams.payeeName}&mc=${upiRequestParams.payeeMerchantCode}&tid=${upiRequestParams.transactionId}&tr=${upiRequestParams.transactionRefId}&am=${upiRequestParams.amount}&cu=INR#Intent;scheme=upi;end";
  }

  static String getUpiAppSchema(String? paymentApp) {
    String scheme = "";
    switch (paymentApp) {
      case "Amazon Pay":
        scheme = "amazonToAlipay://pay";
        break;
      case "BhimUpi":
        scheme = "BHIM://pay";
        break;
      case "Google Pay":
        scheme = "tez://upi/pay";
        break;
      case "Paytm":
        scheme = "paytm://pay";
        break;
      case "PhonePe":
        scheme = "phonepe://pay";
        break;
    }
    return scheme;
  }

  static void redirectToAppstore(String? paymentApp) async {
    String url = "";
    switch (paymentApp) {
      case "Amazon Pay":
        url = "https://apps.apple.com/app/id1478350915";
        break;
      case "BhimUpi":
        url = "https://apps.apple.com/app/id1200315258";
        break;
      case "Google Pay":
        url = "https://apps.apple.com/app/id1193357041";
        break;
      case "Paytm":
        url = "https://apps.apple.com/app/id473941634";
        break;
      case "PhonePe":
        url = "https://apps.apple.com/app/id1170055821";
        break;
    }
    await FlutterNativeUpi(const MethodChannel('flutter_pay_upi'))
        .navigateToAppstore(url);
    // if (await canLaunchUrl(Uri.parse(url))) {
    //     await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}
