import 'package:flutter/services.dart';

class UpiException implements Exception {
  final UpiExceptionType type;
  final String? message;
  final dynamic details;
  final String? stacktrace;

  UpiException({
    required this.type,
    required this.message,
    required this.details,
    required this.stacktrace,
  });

  factory UpiException.fromException(PlatformException exception) {
    UpiExceptionType type;

    switch (exception.code) {
      case 'Cancelled':
        type = UpiExceptionType.cancelledException;
        break;
      case 'Failure':
        type = UpiExceptionType.failedException;
        break;
      case 'Submitted':
        type = UpiExceptionType.submittedException;
        break;
      case 'App Not Found Exception':
        type = UpiExceptionType.appNotFoundException;
        break;
      default:
        type = UpiExceptionType.unknownException;
        break;
    }

    return UpiException(
      type: type,
      message: exception.message,
      details: exception.details,
      stacktrace: exception.stacktrace,
    );
  }
}

enum UpiExceptionType {
  /// when transaction is cancelled by the user.
  cancelledException,

  /// when transaction failed
  failedException,

  /// Transaction is in PENDING state. Money might get deducted from user’s account but not yet deposited in payee’s account.
  submittedException,

  /// Transaction is in PENDING state. Money might get deducted from user’s account but not yet deposited in payee’s account.
  appNotFoundException,

  /// when unknown exception occurs
  unknownException,
}
