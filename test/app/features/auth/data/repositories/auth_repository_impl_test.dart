import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
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

  group('signUp', () {
    const model = AccountModel(
      name: "Jonathan Costa",
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
      phone: "88992967878",
    );

    test('should check if the device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signUp(model)).thenAnswer((_) async => true);
      //act
      await repository.signUp(model);
      //assert
      verify(networkInfo.isConnected);
    });

    test('should return NoConectedException if the device is offline',
        () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      when(dataSource.signUp(model)).thenAnswer((_) async => false);
      //act
      final result = await repository.signUp(model);
      //assert
      verifyZeroInteractions(dataSource);
      expect(result, equals(Left(NoConnectionFailure())));
    });

    test(
        'should return datasource data when the call to datasource is successful',
        () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signUp(model)).thenAnswer((_) async => true);
      //act
      final result = await repository.signUp(model);
      //assert
      verify(dataSource.signUp(model));
      expect(result, equals(const Right(true)));
    });

    test(
        'should return server failure when the call to datasource is unsuccessful',
        () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signUp(model)).thenThrow(const ServerException(
          code: 404, type: "Error", message: "Error Message"));
      //act
      final result = await repository.signUp(model);
      //assert
      verify(dataSource.signUp(model));
      verifyNoMoreInteractions(dataSource);
      expect(result, equals(left(ServerFailure())));
    });
  });
}
