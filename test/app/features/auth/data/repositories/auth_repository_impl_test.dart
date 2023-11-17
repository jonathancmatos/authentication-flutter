import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/token_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../../../bootstrap/modular_test.dart';
import '../../mocks/auth_mock.mocks.dart';


void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDataSource dataSource;
  late MockNetworkInfo networkInfo;
  late PreferencesService preferencesService;
  late SessionManager sessionManager;

  setUpAll(() {
    Modular.init(TestModule());
    preferencesService = Modular.get<PreferencesService>(); 
    sessionManager = Modular.get<SessionManager>();  

    dataSource = MockAuthDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      networkInfo: networkInfo,
      dataSource: dataSource,
    );
  });

  void verifyInfoNetwork(bool value, Function body){
    //arrange
    when(networkInfo.isConnected).thenAnswer((_) async => value);
    //act
    body();
  }

  group('signUp', () {
    const model = AccountModel(
      name: "Jonathan Costa",
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
      phone: "88992967878",
    );

    test('should check if the device is online', () {
      verifyInfoNetwork(true, () async {
        //arrange
        when(dataSource.signUp(model)).thenAnswer((_) async => true);
        //act
        await repository.signUp(model);
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test('should return NoConectedException if the device is offline',() {
      verifyInfoNetwork(false, () async {
        //arrange
        when(dataSource.signUp(model)).thenAnswer((_) async => false);
        //act
        final result = await repository.signUp(model);
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test('should return datasource data when the call to datasource is successful',() {
      verifyInfoNetwork(true, () async {
        //arrange
        when(dataSource.signUp(model)).thenAnswer((_) async => true);
        //act
        final result = await repository.signUp(model);
        //assert
        expect(result, equals(const Right(true)));
        verify(dataSource.signUp(model));
        verifyNoMoreInteractions(dataSource);
      });      
    });

    test('should return server failure when the call to datasource is unsuccessful',(){
      verifyInfoNetwork(true, () async {
       //arrange
       final responseError = await json.decode(fixture("authetication/created_account_error.json"));
       when(dataSource.signUp(model)).thenThrow(
          ServerException(
            code: 400,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.signUp(model);
        //assert
        expect(result, equals(left(const ServerFailure(
          type: "created_error",
          message: "O e-mail informado já existe."
        ))));
        verify(dataSource.signUp(model));
        verifyNoMoreInteractions(dataSource);
      });    
    });
  });

  group("signInWithEmail", (){
    const model = SignInModel(
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
    );

    test('should check if the device is online', (){
      verifyInfoNetwork(true, () async {
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithEmail(model)).thenAnswer((_) async => TokenModel.fromJson(responseSuccess));
        //act
        await repository.signInWithEmail(model);
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test('should return NoConectedException if the device is offline',(){
      verifyInfoNetwork(false, () async {
        //arrange
        final jsonResponse = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithEmail(model)).thenAnswer((_) async => TokenModel.fromJson(jsonResponse));
        //act
        final result = await repository.signInWithEmail(model);
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test('should return datasource data when the call to datasource is successful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithEmail(model)).thenAnswer((_) async => TokenModel.fromJson(responseSuccess));
        when(sessionManager.setAccessToken(responseSuccess["access_token"])).thenAnswer((_) async => true);
        when(sessionManager.setRefreshToken(responseSuccess["refresh_token"])).thenAnswer((_) async => true);
        //act
        final result = await repository.signInWithEmail(model);
        //assert
        expect(result, equals(const Right(true)));
        verify(dataSource.signInWithEmail(model));
        verify(sessionManager.setAccessToken(responseSuccess["access_token"]));
        verify(sessionManager.setRefreshToken(responseSuccess["refresh_token"]));
      });
    });

    test('should return server failure when the call to datasource is unsuccessful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseError = await json.decode(fixture("authetication/login_with_email_error.json"));
        when(dataSource.signInWithEmail(model)).thenThrow(
          ServerException(
            code: 400,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.signInWithEmail(model);
        //assert
        expect(result, equals(const Left(ServerFailure(
          type: "signin_error",
          message: "E-mail ou Senha não são válidos.",
        ))));
        verify(dataSource.signInWithEmail(model));
        verifyNoMoreInteractions(dataSource); 
      });
    });
  });

  group("signInWithGoogle", (){

    test('should check if the device is online', (){
      verifyInfoNetwork(true, () async {
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithGoogle()).thenAnswer((_) async => TokenModel.fromJson(responseSuccess));
        //act
        await repository.signInWithGoogle();
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test('should return NoConectedException if the device is offline',(){
      verifyInfoNetwork(false, () async {
        //arrange
        final jsonResponse = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithGoogle()).thenAnswer((_) async => TokenModel.fromJson(jsonResponse));
        //act
        final result = await repository.signInWithGoogle();
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test('should return datasource data when the call to datasource is successful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signInWithGoogle()).thenAnswer((_) async => TokenModel.fromJson(responseSuccess));
        when(sessionManager.setAccessToken(responseSuccess["access_token"])).thenAnswer((_) async => true);
        when(sessionManager.setRefreshToken(responseSuccess["refresh_token"])).thenAnswer((_) async => true);
        //act
        final result = await repository.signInWithGoogle();
        //assert
        expect(result, equals(const Right(true)));
        verify(dataSource.signInWithGoogle());
        verify(sessionManager.setAccessToken(responseSuccess["access_token"]));
        verify(sessionManager.setRefreshToken(responseSuccess["refresh_token"]));
      });
    });

    test('should return server failure when the call to datasource is unsuccessful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseError = await json.decode(fixture("authetication/login_with_google_error.json"));
        when(dataSource.signInWithGoogle()).thenThrow(
          ServerException(
            code: 00,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.signInWithGoogle();
        //assert
        expect(result, equals(const Left(ServerFailure(
          type: "Error",
          message: "Não foi possível realizar o login com o Google. Por favor, tente novamente.",
        ))));
        verify(dataSource.signInWithGoogle());
        verifyNoMoreInteractions(dataSource); 
      });
    });
  });
  
  group('currentUser', () {
    test("should check if the device is online", (){
      verifyInfoNetwork(true, () async{
        //arrange
        final response = await json.decode(fixture("authetication/current_user_success.json"));
        final user = UserModel.fromJson(response);

        when(dataSource.currentUser()).thenAnswer((_) async => user);
        when(preferencesService.save(key: "user_profile", value:user.toJson().toString())).thenAnswer((_) async => true);
        //act
        await repository.currentUser();
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test("should return NoConectedException if the device is offline", (){
      verifyInfoNetwork(false, () async{
        //arrange
        final response = await json.decode(fixture("authetication/current_user_success.json"));
        when(dataSource.currentUser()).thenAnswer((_) async => response);
        //act
        final result = await repository.currentUser();
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test("should return the data of the logged in user", (){
      verifyInfoNetwork(true, () async{
        //arrange
        final response = await json.decode(fixture("authetication/current_user_success.json"));
        final user = UserModel.fromJson(response);
        when(dataSource.currentUser()).thenAnswer((_) async => user);
        when(preferencesService.save(key: keyProfile, value: user.toJson().toString())).thenAnswer((_) async => true);
        //act
        final result = await repository.currentUser();
        //assert
        expect(result?.isRight(), equals(true));
        verify(preferencesService.save(key: keyProfile, value: user.toJson().toString()));
        verify(dataSource.currentUser());
        verifyNoMoreInteractions(dataSource);
      });
    });

    test("should return a failure when retrieving user data", (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseError = await json.decode(fixture("authetication/current_user_error.json"));
        when(dataSource.currentUser()).thenThrow(
          ServerException(
            code: 401,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.currentUser();
        //assert
        expect(result, equals(left(
          const ServerFailure(
            type: "token_expired",
            message: "Expired token",
          ),
        )));
        verify(dataSource.currentUser());
        verifyNoMoreInteractions(dataSource);
      });
    });

  });

  group('logout', () {
    test("should check if the device is online", (){
      verifyInfoNetwork(true, () async{
        //arrange
        when(dataSource.logout()).thenAnswer((_) async => true);
        //act
        await repository.logout();
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test("should return NoConectedException if the device is offline", (){
      verifyInfoNetwork(false, () async{
        //arrange
        when(dataSource.logout()).thenAnswer((_) async => true);
        //act
        final result = await repository.logout();
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test("should return true when performing logout", (){
      verifyInfoNetwork(true, () async{
        //arrange
        final response = await json.decode(fixture("authetication/logout_success.json"))["response"];
        when(dataSource.logout()).thenAnswer((_) async => response["message"]);
        //act
        final result = await repository.logout();
        //assert
        expect(result?.isRight(), equals(true));
        verify(dataSource.logout());
        verifyNoMoreInteractions(dataSource);
      });
    });

    test("should return a failure when trying to logout", (){
      verifyInfoNetwork(true, () async{
        //arrange
        final response = await json.decode(fixture("authetication/logout_error.json"))["response"];
        when(dataSource.logout()).thenThrow(
          ServerException(
            code: 400, 
            type: response["type"], 
            message: response["message"],
        ));
        //act
        final result = await repository.logout();
        //assert
        expect(result, equals(left(
          const ServerFailure(
            type: "logout_error", 
            message: "Não foi possível fazer o logout. Por favor, tente novamente."
        ))));
        verify(dataSource.logout());
        verifyNoMoreInteractions(dataSource);
      });
    });
  });

  group('refreshToken', (){
    test('should check if the device in online', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final refreshToken = await json.decode(fixture("authetication/login_success.json"))["refresh_token"];
        when(sessionManager.getRefreshToken()).thenAnswer((_) => refreshToken);
        when(dataSource.refreshAccessToken(refreshToken)).thenAnswer((_) async => refreshToken);
        when(sessionManager.setAccessToken(refreshToken)).thenAnswer((_) async => true);
        //act
        await repository.refreshAccessToken();
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test('should return NoConectedException if the device is offline', (){
      verifyInfoNetwork(false, () async{
        //arrange
        final refreshToken = await json.decode(fixture("authetication/login_success.json"))["refresh_token"];
        when(dataSource.refreshAccessToken("value")).thenAnswer((_) async => refreshToken);
        //act
        final result = await repository.refreshAccessToken();
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test('should return a new access_token in case of [200] ', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final refreshToken = await json.decode(fixture("authetication/login_success.json"))["refresh_token"];
        when(sessionManager.getRefreshToken()).thenAnswer((_) => refreshToken);
        when(dataSource.refreshAccessToken(refreshToken)).thenAnswer((_) async => refreshToken);
        when(sessionManager.setAccessToken(refreshToken)).thenAnswer((_) async => true);
        //act
        final result = await repository.refreshAccessToken();
        //assert
        expect(result?.isRight(), equals(true));
        verify(sessionManager.getRefreshToken());
        verify(dataSource.refreshAccessToken(refreshToken));
        verify(sessionManager.setAccessToken(refreshToken));
        verifyNoMoreInteractions(dataSource);
      });
    });

    test('should return a failure when refreshing the access_token', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final refreshToken = await json.decode(fixture("authetication/login_success.json"))["refresh_token"];
        when(sessionManager.getRefreshToken()).thenAnswer((_) => refreshToken);
        when(dataSource.refreshAccessToken(refreshToken)).thenThrow(
          ServerException(
          code: 401, 
          type: "unauthorized", 
          message: "Signature verification failed"
        ));
        //act
        final result = await repository.refreshAccessToken();
        //assert
        expect(result, equals(const Left(
          ServerFailure(
            type: "unauthorized", 
            message: "Signature verification failed" 
        ))));
        verify(sessionManager.getRefreshToken());
        verify(dataSource.refreshAccessToken(refreshToken));
        verifyNoMoreInteractions(dataSource);
      });
    });
  });

}
