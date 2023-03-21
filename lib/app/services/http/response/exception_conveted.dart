import 'package:authentication_flutter/app/core/error/exception.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

const _codeError = 00;
const _typeError = "Error";
const _messageError = "O servidor retornou um erro inesperado.";

ServerException serverExceptionConverted(Response? response) {
  if (response != null && response.data != null) {
    final error = response.data;
    return ServerException(
      code: response.statusCode ?? _codeError,
      type: error["response"]["type"] ?? _typeError,
      message: error["response"]["message"] ?? _messageError,
    );
  }

  return const ServerException(
    code: _codeError,
    type: _typeError,
    message: _messageError,
  );
}
