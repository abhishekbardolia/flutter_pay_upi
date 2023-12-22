/// Represents the response received after a UPI (Unified Payments Interface) transaction.
///
/// This class includes fields such as transaction ID, response code, approval reference number,
/// transaction status, and transaction reference ID. Instances of this class can be created using
/// the [UpiResponse.fromResponseString] factory method, which parses a response string and builds
/// an instance of [UpiResponse].
///
/// Example Usage:
/// ```dart
/// UpiResponse upiResponse = UpiResponse.fromResponseString(responseString);
/// ```
class UpiResponse {
  String? transactionID;
  String? responseCode;
  String? approvalReferenceNo;
  String? status;
  String? transactionReferenceId;

  UpiResponse._builder(UpiResponseBuilder builder) {
    transactionID = builder.transactionID;
    responseCode = builder.responseCode;
    approvalReferenceNo = builder.approvalReferenceNo;
    status = builder.status;
    transactionReferenceId = builder.transactionReferenceId;
  }

  /// Factory method to create an instance of [UpiResponse] from a UPI response string.
  ///
  /// Parameters:
  /// - [responseString]: The UPI response string received after a transaction.
  ///
  /// Returns:
  /// An instance of [UpiResponse] with parsed information from the response string.
  factory UpiResponse.fromResponseString(String responseString) {
    final builder = UpiResponseBuilder();

    List<String> partOfResponse = responseString.split('&');
    for (int i = 0; i < partOfResponse.length; ++i) {
      String key = partOfResponse[i].split('=')[0];
      String value = partOfResponse[i].split('=')[1];
      builder._processKeyValue(key.toLowerCase(), value);
    }

    return UpiResponse._builder(builder);
  }
}

/// A builder class for constructing [UpiResponse] from a UPI response string.
class UpiResponseBuilder {
  String? transactionID;
  String? responseCode;
  String? approvalReferenceNo;
  String? status;
  String? transactionReferenceId;

  void _processKeyValue(String key, String value) {
    if (key == "txnid") {
      transactionID = _getValue(value);
    } else if (key == "responsecode") {
      responseCode = _getValue(value);
    } else if (key == "approvalrefno") {
      approvalReferenceNo = _getValue(value);
    } else if (key == "status") {
      if (value.toLowerCase().contains("success")) {
        status = UpiPaymentStatus.SUCCESS;
      } else if (value.toLowerCase().contains("fail")) {
        status = UpiPaymentStatus.FAILURE;
      } else if (value.toLowerCase().contains("submit")) {
        status = UpiPaymentStatus.SUBMITTED;
      } else {
        status = UpiPaymentStatus.OTHER;
      }
    } else if (key == "txnref") {
      transactionReferenceId = _getValue(value);
    }
  }

  String? _getValue(String? s) {
    if (s == null ||
        s.isEmpty ||
        s.toLowerCase() == 'null' ||
        s.toLowerCase() == 'undefined') {
      return null;
    } else {
      return s;
    }
  }

  /// Builds and returns the final [UpiResponse] instance.
  UpiResponse build() {
    return UpiResponse._builder(this);
  }
}

/// Constants representing UPI payment status values.
class UpiPaymentStatus {
  static const String SUCCESS = 'success';
  static const String SUBMITTED = 'submitted';
  static const String FAILURE = 'failure';
  static const String OTHER = 'other';
}
