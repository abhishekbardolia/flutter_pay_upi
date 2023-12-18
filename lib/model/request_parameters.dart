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

  factory UPIRequestParameters.builder(Function(UPIRequestBuilder) buildFunc) {
    final builder = UPIRequestBuilder._(UPIRequestParameters._());
    buildFunc(builder);
    return builder._build();
  }
}

class UPIRequestBuilder {
  final UPIRequestParameters _upi;

  UPIRequestBuilder._(this._upi);

  void setPaymentApp(String? paymentApp) {
    _upi.paymentApp = paymentApp;
  }

  void setPayeeVpa(String? payeeVpa) {
    _upi.payeeVpa = payeeVpa;
  }

  void setPayeeName(String? payeeName) {
    _upi.payeeName = payeeName;
  }

  void setTransactionId(String? transactionId) {
    _upi.transactionId = transactionId;
  }

  void setTransactionRefId(String? transactionRefId) {
    _upi.transactionRefId = transactionRefId;
  }

  void setPayeeMerchantCode(String? payeeMerchantCode) {
    _upi.payeeMerchantCode = payeeMerchantCode;
  }

  void setDescription(String? description) {
    _upi.description = description;
  }

  void setAmount(String? amount) {
    _upi.amount = amount;
  }

  //INR
  void setCurrency(String? currency) {
    _upi.currency = currency;
  }

  UPIRequestParameters _build() {
    return _upi;
  }
}
