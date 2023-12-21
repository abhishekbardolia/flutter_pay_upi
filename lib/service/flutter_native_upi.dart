import 'package:flutter/services.dart';
import 'package:flutter_pay_upi/model/request_parameters.dart';
import 'package:flutter_pay_upi/utils/exception.dart';
import '../model/upi_app_model.dart';
import '../model/upi_response.dart';

class FlutterNativeUpi {
  final MethodChannel _channel;

  FlutterNativeUpi(this._channel);

  Future<UpiResponse> initiateTransaction(
      UPIRequestParameters upiRequestParams) async {
    try {
      final String? response =
          await _channel.invokeMethod('initiateTransaction', {
        "app": upiRequestParams.paymentApp,
        'pa': upiRequestParams.payeeVpa,
        'pn': upiRequestParams.payeeName,
        'mc': upiRequestParams.payeeMerchantCode,
        'tr': upiRequestParams.transactionId,
        'trref':
            upiRequestParams.transactionRefId ?? upiRequestParams.transactionId,
        'tn': upiRequestParams.description ?? upiRequestParams.transactionId,
        'am': makeDecimal(upiRequestParams.amount!),
        'cu': upiRequestParams.currency ?? "INR",
        'url': "",
      });
      if (response != null && response != "User Cancelled transaction") {
        UpiResponse upiResponse = UpiResponse.fromResponseString(response);
        if (upiResponse.status == "Failure") {
          throw UpiException.fromException(
            PlatformException(
              code: "Failure",
              details: 'Transaction Failure',
              message: 'Transaction Failure',
            ),
          );
        }
        return upiResponse;
      } else if (response == "User Cancelled transaction") {
        throw UpiException.fromException(
          PlatformException(
            code: "Cancelled",
            details: 'User cancelled the transaction',
            message: 'Transaction cancelled',
          ),
        );
      } else {
        throw UpiException.fromException(
          PlatformException(
            code: UpiExceptionType.unknownException.toString(),
            details: 'No response from the payment',
            message: 'No response',
          ),
        );
      }
    } on PlatformException catch (e) {
      throw UpiException.fromException(e);
    } catch (e) {
      if ((e as UpiException).type == UpiExceptionType.cancelledException) {
        throw UpiException.fromException(
          PlatformException(
            code: "Cancelled",
            details: 'User cancelled the transaction',
            message: 'Transaction cancelled',
          ),
        );
      } else {
        throw UpiException(
          type: UpiExceptionType.unknownException,
          message: "Something error",
          details: e.toString(),
          stacktrace: e.toString(),
        );
      }
    }
  }

  Future<List<UpiApp>> getAllUpiApps() async {
    final List<Map>? apps = await _channel.invokeListMethod<Map>('allUPIApps');
    List<UpiApp> upiIndiaApps = [];
    apps?.forEach((Map app) {
      if (app['packageName'] == "in.org.npci.upiapp" ||
              app['packageName'] == "com.google.android.apps.nbu.paisa.user" ||
              app['packageName'] == "com.phonepe.app" ||
              app['packageName'] == "in.amazon.mShop.android.shopping" ||
              app['packageName'] == "net.one97.paytm"
      ///Coming soon
          // app['packageName'] == "com.freecharge.android" ||
          // app['packageName'] == "com.axis.mobile" ||
          // app['packageName'] == "com.infrasofttech.centralbankupi" ||
          // app['packageName'] == "com.infra.boiupi" ||
          // app['packageName'] == "com.lcode.corpupi" ||
          // app['packageName'] == "com.lcode.csbupi" ||
          // app['packageName'] == "com.dbs.in.digitalbank" ||
          // app['packageName'] == "com.equitasbank.upi" ||
          // app['packageName'] == "com.mgs.hsbcupi" ||
          // app['packageName'] == "com.csam.icici.bank.imobile" ||
          // app['packageName'] == "com.lcode.smartz" ||
          // app['packageName'] == "com.mgs.induspsp" ||
          // app['packageName'] == "com.msf.kbank.mobile" ||
          // app['packageName'] == "com.hdfcbank.payzapp" ||
          // app['packageName'] == "com.Version1" ||
          // app['packageName'] == "com.psb.omniretail" ||
          // app['packageName'] == "com.rblbank.mobank" ||
          // app['packageName'] == "com.lcode.ucoupi" ||
          // app['packageName'] == "com.ultracash.payment.customer" ||
          // app['packageName'] == "com.YesBank" ||
          // app['packageName'] == "com.bankofbaroda.upi" ||
          // app['packageName'] == "com.myairtelapp" ||
          // app['packageName'] == "com.dreamplug.androidapp" ||
          // app['packageName'] == "com.sbi.upi"
          ) {
        // || app['packageName']== "com.whatsapp"
        // || app['packageName']== "com.whatsapp.w4b") {
        upiIndiaApps.add(UpiApp.fromMap(Map<String, dynamic>.from(app)));
      }
    });
    return upiIndiaApps;
  }

  Future<String> initiateTransactioniOS(String? url) async {
    try {
      final result = await _channel.invokeMethod(
        'initiateTransaction',
        {
          'uri': url,
        },
      );
      return result == true
          ? "Successfully Launched App!"
          : "Please install app!";
    } catch (error) {
      throw Exception(error);
    }
  }
  Future<void> navigateToAppstore(String? url) async {
    try {
      await _channel.invokeMethod(
        'navigateToAppstore',
        {
          'uri': url,
        },
      );
    } catch (error) {
      throw Exception(error);
    }
  }

  String makeDecimal(String amount) {
    if (isValidDecimal(amount)) {
      try {
        double parsedAmount = double.parse(amount);
        return parsedAmount.toStringAsFixed(2);
      } catch (e) {
        return '0.00';
      }
    }

    // If the amount is not a valid decimal, try converting it
    try {
      double parsedAmount = double.parse(amount);
      return parsedAmount.toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  bool isValidDecimal(String input) {
    RegExp decimalRegExp = RegExp(r'^\d*\.?\d+$');
    return decimalRegExp.hasMatch(input);
  }
}
