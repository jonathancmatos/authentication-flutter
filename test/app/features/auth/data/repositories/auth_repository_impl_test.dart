import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
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

  setUp(() { 
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
        verifyZeroInteractions(dataSource);
        expect(result, equals(Left(NoConnectionFailure())));
      });
    });

    test('should return datasource data when the call to datasource is successful',() {
      verifyInfoNetwork(true, () async {
        //arrange
        when(dataSource.signUp(model)).thenAnswer((_) async => true);
        //act
        final result = await repository.signUp(model);
        //assert
        verify(dataSource.signUp(model));
        expect(result, equals(const Right(true)));
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
        verify(dataSource.signUp(model));
        verifyNoMoreInteractions(dataSource);
        expect(result, equals(left(const ServerFailure(
          type: "invalid_data",
          message: "O e-mail informado já existe."
        ))));
      });    
    });
  });


  group("signIn", (){
    Modular.init(TestModule());
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
        verifyNoMoreInteractions(dataSource);
        expect(result, equals(Left(NoConnectionFailure())));
      });
    });

    test('should return datasource data when the call to datasource is successful', (){
      verifyInfoNetwork(true, () async{
        //arrange
        final responseSuccess = await json.decode(fixture("authetication/login_success.json"));
        when(dataSource.signIn(model)).thenAnswer((_) async => responseSuccess);
        //act
        final result = await repository.signIn(model);
        //assert
        verify(dataSource.signIn(model));
        expect(result, equals(const Right(true)));
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
        verify(dataSource.signIn(model));
        verifyNoMoreInteractions(dataSource);
        expect(result, equals(const Left(ServerFailure(
          type: "Error",
          message: "E-mail ou Senha não são válidos.",
        ))));
      });
    });
  });

}
