import 'dart:io';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/http/response/exception_conveted.dart';
import 'package:dio/dio.dart';

abstract class AuthDataSource {
  Future<bool>? signUp(AccountModel model);
}

class AuthDataSourceImpl extends AuthDataSource {
  HttpService httpService;
  AuthDataSourceImpl(this.httpService);

  @override
  Future<bool>? signUp(AccountModel model) async {
    try {
      final formData = FormData.fromMap(model.toJson());
      final response = await httpService.post(
        "$baseUrl/signup",
        data: formData,
      );
      
      return response.statusCode == 200;

    } on DioError catch (e) {
      throw serverExceptionConverted(e.response);
    } on SocketException {
      throw NoConnectionException();
    } on Exception {
      throw InternalException();
    }
  }
}
