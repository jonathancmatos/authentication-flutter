import 'dart:io';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/token_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:dio/dio.dart';

abstract class AuthDataSource {
  Future<bool>? signUp(AccountModel model);
  Future<TokenModel>? signIn(SignInModel model);
  Future<UserModel>? currentUser();
  Future<bool>? logout();
  Future<String>? refreshAccessToken(String refreshToken);
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
      throw ServerException(response: e.response);
    } on SocketException {
      throw NoConnectionException();
    } on Exception {
      throw InternalException();
    }
  }

  @override
  Future<TokenModel>? signIn(SignInModel model) async {
    try {
      final formData = FormData.fromMap(model.toJson());
      final response = await httpService.post(
        "$baseUrl/signin",
        data: formData,
      );

      if (response.statusCode != 200) {
        throw InternalException();
      }

      return TokenModel.fromJson(response.data);
      
    } on DioError catch (e) {
      throw ServerException(response: e.response);
    } on SocketException {
      throw NoConnectionException();
    } on Exception {
      throw InternalException();
    }
  }
  
  @override
  Future<UserModel>? currentUser() async{
    try{

      final response = await httpService.get("$baseUrl/current-user");
      if(response.statusCode == 200){
        return UserModel.fromJson(response.data);
      }

      return throw InternalException();

    } on DioError catch (e) {
      throw ServerException(response: e.response);
    } on SocketException {
      throw NoConnectionException();
    } on Exception {
      throw InternalException();
    }
  }
  
  @override
  Future<bool>? logout() async{
    try{
      
      final response = await httpService.post("$baseUrl/logout");
      return response.statusCode == 200;

    }on DioError catch(e){
      throw ServerException(response: e.response);
    }on SocketException{
      throw NoConnectionException();
    } on Exception{
      throw InternalException();
    }
  }
  
  @override
  Future<String>? refreshAccessToken(String refreshToken) async{
    try{

      final response = await httpService.post(
        "$baseUrl/refresh-token",
        data: FormData.fromMap({"refresh_token":refreshToken}),
      );

      if(response.statusCode != 200){
        return "";
      }

      return response.data["response"]["message"];

    }on DioError catch(e){
      throw ServerException(response: e.response);
    }on SocketException{
      throw NoConnectionException();
    }on Exception{
      throw InternalException();
    }
  }
}
