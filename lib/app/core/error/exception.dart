import 'package:authentication_flutter/app/core/error/entities/error_response.dart';

class ServerException extends ErrorResponse implements Exception {

  ServerException({
    dynamic response,
    int code = 00,
    String type = "Error",
    String message = "O servidor retornou um erro inesperado.",
  }) : super(code: code, type: type, message: message){

    if (response != null && response.data != null) {
      final error = response.data;
      code = response.statusCode ?? this.code;
      type = error["response"]["type"] ?? this.type;
      message = error["response"]["message"] ?? this.message;
    }

  }
}

class InternalException implements Exception {}

class NoConnectionException implements Exception {}
