import 'package:authentication_flutter/app/core/error/entities/error_response.dart';

class ServerException extends ErrorResponse implements Exception {

  const ServerException({
    int code = 00,
    String type = "Error",
    String message = "O servidor retornou um erro inesperado.",
  }) : super(code: code, type: type, message: message);

  factory ServerException.fromData(dynamic response){
    return ServerException(
      code: response.statusCode ?? 00,
      type: response.data["response"]["type"],
      message: response.data["response"]["message"]
    );
  }
}

class InternalException implements Exception {}

class NoConnectionException implements Exception {}