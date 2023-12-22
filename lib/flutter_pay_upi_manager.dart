import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pay_upi/service/flutter_native_upi.dart';
import 'package:flutter_pay_upi/service/get_upi_app_list.dart';
import 'package:flutter_pay_upi/utils/exception.dart';

import 'model/request_parameters.dart';
import 'model/upi_app_model.dart';
import 'model/upi_ios_model.dart';
import 'model/upi_response.dart';

/// A manager class for handling UPI (Unified Payments Interface) transactions using Flutter.
///
/// This class provides static methods to interact with UPI apps on both Android and iOS platforms.
class FlutterPayUpiManager {
  /// Retrieves a list of UPI apps available on Android.
  static Future<List<UpiApp>> getListOfAndroidUpiApps() async {
    return await GetUpiAppsAndroid().getUpiApps();
  }

  /// Retrieves a list of UPI apps available on iOS.
  static Future<List<UpiIosModel>> getListOfIosUpiApps() async {
    return await GetUpiAppsiOS().getUpiApps();
  }

  /// Initiates a UPI payment transaction.
  ///
  /// Parameters:
  /// - [paymentApp]: The UPI payment app to be used for the transaction.
  /// - [payeeVpa]: The VPA (Virtual Payment Address) of the payee.
  /// - [payeeName]: The name of the payee.
  /// - [transactionId]: The unique ID for the transaction.
  /// - [transactionRefId]: The reference ID for the transaction (optional).
  /// - [payeeMerchantCode]: The merchant code of the payee.
  /// - [description]: The description of the transaction.
  /// - [amount]: The amount to be transferred.
  /// - [currency]: The currency for the transaction (default is "INR").
  /// - [response]: A callback function to handle the UPI response.
  /// - [error]: A callback function to handle errors during the transaction.
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

  // Additional methods for URL generation and redirection
  static String appendAndMakeUrl(UPIRequestParameters upiRequestParams) {
    return "${getUpiAppSchema(upiRequestParams.paymentApp)}?pa=${upiRequestParams.payeeVpa}&pn=${upiRequestParams.payeeName}&mc=${upiRequestParams.payeeMerchantCode}&tid=${upiRequestParams.transactionId}&tr=${upiRequestParams.transactionRefId}&am=${upiRequestParams.amount}&cu=INR#Intent;scheme=upi;end";
  }

  /// Returns the UPI app scheme based on the provided payment app name.
  ///
  /// This method takes a [paymentApp] name as input and maps it to the corresponding
  /// UPI app scheme. The scheme is used to initiate a UPI payment transaction on iOS.
  /// If the [paymentApp] is not recognized, an empty string is returned.
  ///
  /// Supported UPI apps and their schemes:
  /// - "Amazon Pay" : "amazonToAlipay://pay"
  /// - "BhimUpi"    : "BHIM://pay"
  /// - "Google Pay" : "tez://upi/pay"
  /// - "Paytm"      : "paytm://pay"
  /// - "PhonePe"    : "phonepe://pay"
  ///
  /// Parameters:
  /// - [paymentApp]: The name of the UPI payment app.
  ///
  /// Returns:
  /// A String representing the UPI app scheme.
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

  /// Redirects the user to the App Store to download the UPI payment app.
  ///
  /// This method takes the name of the UPI payment app ([paymentApp]) as input
  /// and constructs the App Store URL for the corresponding app. It then uses
  /// the FlutterNativeUpi plugin to navigate to the App Store.
  ///
  /// Supported UPI payment apps and their App Store URLs:
  /// - "Amazon Pay" : [https://apps.apple.com/app/id1478350915](https://apps.apple.com/app/id1478350915)
  /// - "BhimUpi"    : [https://apps.apple.com/app/id1200315258](https://apps.apple.com/app/id1200315258)
  /// - "Google Pay" : [https://apps.apple.com/app/id1193357041](https://apps.apple.com/app/id1193357041)
  /// - "Paytm"      : [https://apps.apple.com/app/id473941634](https://apps.apple.com/app/id473941634)
  /// - "PhonePe"    : [https://apps.apple.com/app/id1170055821](https://apps.apple.com/app/id1170055821)
  ///
  /// Parameters:
  /// - [paymentApp]: The name of the UPI payment app.
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
  }
}
