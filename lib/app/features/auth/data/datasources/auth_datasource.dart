import 'dart:io';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/token_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/social/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthDataSource {
  Future<bool>? signUp(AccountModel model);
  Future<TokenModel>? signInWithEmail(SignInModel model);
  Future<TokenModel>? signInWithGoogle();
  Future<UserModel>? currentUser();
  Future<bool>? logout();
  Future<String>? refreshAccessToken(String refreshToken);
}

class AuthDataSourceImpl extends AuthDataSource {

  HttpService httpService;
  GoogleAuth googleAuth;

  AuthDataSourceImpl({
    required this.httpService,
    required this.googleAuth
  });

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
  Future<TokenModel>? signInWithEmail(SignInModel model) async {
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
  Future<TokenModel>? signInWithGoogle() async{
   try {

      final result = (await googleAuth.signIn()) as GoogleSignInAccount?;
      final model = UserModel(
        googleId: result?.id ?? '',
        name: result?.displayName ?? '', 
        email: result?.email ?? '', 
        phone: ''
      );

      final formData = FormData.fromMap(model.toJson()); 
      final response = await httpService.post(
        "$baseUrl/google-sign-in",
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
      
      final store = Modular.get<UserManagerStore>();
      final googleId = store.user?.googleId ?? '';

      if(googleId.isNotEmpty){
        await googleAuth.logout();
      }

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
