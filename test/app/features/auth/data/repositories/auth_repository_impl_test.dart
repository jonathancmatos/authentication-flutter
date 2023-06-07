import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
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
            code: 404,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.signUp(model);
        //assert
        expect(result, equals(left(const ServerFailure(
          type: "invalid_data",
          message: "O e-mail informado já existe."
        ))));
        verify(dataSource.signUp(model));
        verifyNoMoreInteractions(dataSource);
      });    
    });
  });

  group("signIn", (){
    const model = SignInModel(
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
    );

    test('should check if the device is online', (){
      verifyInfoNetwork(true, () async {
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signIn(model)).thenAnswer((_) async => responseSuccess);
        //act
        await repository.signIn(model);
        //assert
        verify(networkInfo.isConnected);
      });
    });

    test('should return NoConectedException if the device is offline',(){
      verifyInfoNetwork(false, () async {
        //arrange
        when(dataSource.signIn(model)).thenAnswer((_) async => {});
        //act
        final result = await repository.signIn(model);
        //assert
        expect(result, equals(Left(NoConnectionFailure())));
        verify(networkInfo.isConnected);
      });
    });

    test('should return datasource data when the call to datasource is successful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signIn(model)).thenAnswer((_) async => responseSuccess);
        when(sessionManager.setAccessToken(responseSuccess["access_token"])).thenAnswer((_) async => true);
        when(sessionManager.setRefreshToken(responseSuccess["refresh_token"])).thenAnswer((_) async => true);
        //act
        final result = await repository.signIn(model);
        //assert
        expect(result, equals(const Right(true)));
        verify(dataSource.signIn(model));
        verify(sessionManager.setAccessToken(responseSuccess["access_token"]));
        verify(sessionManager.setRefreshToken(responseSuccess["refresh_token"]));
      });
    });

    test('should return server failure when the call to datasource is unsuccessful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseError = await json.decode(fixture("authetication/login_error.json"));
        when(dataSource.signIn(model)).thenThrow(
          ServerException(
            code: 404,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.signIn(model);
        //assert
        expect(result, equals(const Left(ServerFailure(
          type: "Error",
          message: "E-mail ou Senha não são válidos.",
        ))));
        verify(dataSource.signIn(model));
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
            code: 404,
            type: responseError["response"]["type"],
            message: responseError["response"]["message"],
          ),
        );
        //act
        final result = await repository.currentUser();
        //assert
        expect(result, equals(left(
          const ServerFailure(
            type: "Error",
            message: "Houve um erro ao tentar recuperar dados do usuário",
          ),
        )));
        verify(dataSource.currentUser());
        verifyNoMoreInteractions(dataSource);
      });
    });

  });
}
