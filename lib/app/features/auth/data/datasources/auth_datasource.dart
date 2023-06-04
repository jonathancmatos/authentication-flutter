import 'dart:io';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/http/response/exception_conveted.dart';
import 'package:dio/dio.dart';

abstract class AuthDataSource {
  Future<bool>? signUp(AccountModel model);
  Future<Map<String, dynamic>>? signIn(SignInModel model);
  Future<UserModel>? currentUser();
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

  @override
  Future<Map<String, dynamic>>? signIn(SignInModel model) async {
    try {
      final formData = FormData.fromMap(model.toJson());
      final response = await httpService.post(
        "$baseUrl/signin",
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } on DioError catch (e) {
      throw serverExceptionConverted(e.response);
    } on SocketException {
      throw NoConnectionException();
    } on Exception {
      throw InternalException();
    }
  }
  
  @override
  Future<UserModel>? currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }
}
