import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pay_upi/flutter_pay_upi_manager.dart';
import 'package:flutter_pay_upi/model/upi_response.dart';
import 'package:flutter_pay_upi/utils/widget/upi_app_list.dart';

class FlutterPayUPI extends StatefulWidget {
  const FlutterPayUPI({super.key});

  @override
  _FlutterPayUPIState createState() => _FlutterPayUPIState();
}

class _FlutterPayUPIState extends State<FlutterPayUPI> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? paymentApp;
  String? payeeVpa;
  String? payeeName;
  String? payeeMerchantCode;
  String? transactionId;
  String? description;
  String? amount;
  String? currency;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // buildTextField("Payment App", (value) => paymentApp = value),
                buildTextField("Payee VPA", (value) => payeeVpa = value),
                SizedBox(height: 8),
                buildTextField("Payee Name", (value) => payeeName = value),
                SizedBox(height: 8),
                buildTextField("Payee Merchant Code",
                    (value) => payeeMerchantCode = value),
                SizedBox(height: 8),
                buildTextField(
                    "Transaction ID", (value) => transactionId = value),
                SizedBox(height: 8),
                buildTextField("Description", (value) => description = value),
                SizedBox(height: 8),
                buildTextField("Amount", (value) => amount = value,
                    keyboardType: TextInputType.number),
                SizedBox(height: 8),
                buildCurrencyDropdown(),
                SizedBox(height: 20),
                Expanded(
                  child: UPIAppList(onClick: (upiApp) async {
                    if (_formKey.currentState!.validate()) {
                      FlutterPayUpiManager.startPayment(
                          paymentApp: upiApp!,
                          payeeVpa: payeeVpa!,
                          payeeName: payeeName!,
                          transactionId: transactionId!,
                          payeeMerchantCode: payeeMerchantCode!,
                          description: description!,
                          amount: amount!,
                          response: (UpiResponse response, String amount) {
                            _showTransactionDetailsDialog(response, amount);
                          },
                          error: (e) {
                            _showRoundedDialog(context, e.toString());
                          });
                    }
                  }), // UPIAppList takes the available height
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, void Function(String?) onChanged,
      {TextInputType? keyboardType}) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      ),
    );
  }

  Widget buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: currency,
      onChanged: (String? value) {
        setState(() {
          currency = value;
        });
      },
      items: ['INR'].map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
      ),
    );
  }

  void _showRoundedDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('$message'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTransactionDetailsDialog(
      UpiResponse upiRequestParams, String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Transaction Details'),
          children: [
            _buildDetailRow('Txn ID', upiRequestParams.transactionID ?? "N/A"),
            _buildDetailRow(
                'Response Code', upiRequestParams.responseCode ?? "N/A"),
            _buildDetailRow('Approval Reference No',
                upiRequestParams.approvalReferenceNo ?? "N/A"),
            _buildDetailRow(
                'Txn Ref Id', upiRequestParams.transactionReferenceId ?? "N/A"),
            _buildDetailRow('Status', upiRequestParams.status ?? "N/A"),
            _buildDetailRow('Amount', amount),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          Text('$key:', style: TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // isLoading
      if (Platform.isIOS) {
        ///Develop a method to verify transactions, as iOS does not provide an
        ///immediate response upon successful payment. The verification process
        ///involves checking the method when the application regains focus to
        ///determine whether the transaction was successful.
      }
    }
  }
}
