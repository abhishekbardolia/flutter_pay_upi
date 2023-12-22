/// Represents the parameters required for initiating a UPI (Unified Payments Interface) transaction.
///
/// This class includes fields such as payment app, payee VPA (Virtual Payment Address),
/// payee name, transaction ID, transaction reference ID, description, amount, and currency.
///
/// Usage:
/// ```dart
/// UPIRequestParameters upiRequestParams = UPIRequestParameters.builder((upiRequestBuilder) {
///   upiRequestBuilder
///     ..setPaymentApp("Google Pay")
///     ..setPayeeVpa("example@upi")
///     ..setPayeeName("Abhishek Bardolia")
///     ..setTransactionId("12345")
///     ..setDescription("Payment for goods")
///     ..setAmount("100.00")
///     ..setCurrency("INR");
/// });
/// ```
///
class UPIRequestParameters {
  String? paymentApp;
  String? payeeVpa;
  String? payeeName;
  String? payeeMerchantCode;
  String? transactionId;
  String? transactionRefId;
  String? description;
  String? amount;
  String? currency;

  UPIRequestParameters._(); // Private Constructor

  /// Factory method to create an instance of [UPIRequestParameters] using the builder pattern.
  ///
  /// Parameters:
  /// - [buildFunc]: A function that takes a [UPIRequestBuilder] as a parameter
  ///   and allows setting various parameters for UPI transaction.
  ///
  factory UPIRequestParameters.builder(Function(UPIRequestBuilder) buildFunc) {
    final builder = UPIRequestBuilder._(UPIRequestParameters._());
    buildFunc(builder);
    return builder._build();
  }
}

class UPIRequestBuilder {
  final UPIRequestParameters _upi;

  UPIRequestBuilder._(this._upi);

  /// Sets the payment app for the UPI transaction.
  void setPaymentApp(String? paymentApp) {
    _upi.paymentApp = paymentApp;
  }

  /// Sets the payee VPA (Virtual Payment Address) for the UPI transaction.
  void setPayeeVpa(String? payeeVpa) {
    _upi.payeeVpa = payeeVpa;
  }

  /// Sets the payee name for the UPI transaction.
  void setPayeeName(String? payeeName) {
    _upi.payeeName = payeeName;
  }

  /// Sets the transaction ID for the UPI transaction.
  void setTransactionId(String? transactionId) {
    _upi.transactionId = transactionId;
  }

  /// Sets the transaction reference ID for the UPI transaction.
  void setTransactionRefId(String? transactionRefId) {
    _upi.transactionRefId = transactionRefId;
  }

  /// Sets the payee merchant code for the UPI transaction.
  void setPayeeMerchantCode(String? payeeMerchantCode) {
    _upi.payeeMerchantCode = payeeMerchantCode;
  }

  /// Sets the description for the UPI transaction.
  void setDescription(String? description) {
    _upi.description = description;
  }

  /// Sets the amount for the UPI transaction.
  void setAmount(String? amount) {
    _upi.amount = amount;
  }

  //INR
  void setCurrency(String? currency) {
    _upi.currency = currency;
  }

  /// Builds and returns the final [UPIRequestParameters] instance.
  UPIRequestParameters _build() {
    return _upi;
  }
}
