import 'package:authentication_flutter/app/core/error/entities/error_response.dart';

class ServerException extends ErrorResponse implements Exception {
  const ServerException({
    required int code,
    required String type,
    required String message,
  }) : super(code: code, type: type, message: message);
}

class InternalException implements Exception {}

class NoConnectionException implements Exception {}
