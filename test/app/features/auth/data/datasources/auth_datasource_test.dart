import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late MockDioHttpService mockHttpService;
  late AuthDataSourceImpl authDataSource;

  setUp(() {
    mockHttpService = MockDioHttpService();
    authDataSource = AuthDataSourceImpl(mockHttpService);
  });

  group("signUp", () {
    const model = AccountModel(
        name: "Jonathan Costa",
        email: "contato@devjonathan.com",
        passwd: "12345678",
        phone: "88996770054");

    test('should return true when registering a new user ', () async {
      //arrange
      final response = fixture("authetication/created_account_success.json");
      when(mockHttpService.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      //act
      final result = await authDataSource.signUp(model);
      //assert
      expect(result, true);
    });

    test('should return Server Exception when registering a new user ',
        () async {
      //arrange
      final response =
          json.decode(fixture("authetication/created_account_error.json"));
      when(mockHttpService.post(any, data: anyNamed('data'))).thenThrow(
        DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signUp;
      //assert
      expect(() async => await call(model), throwsA(isA<ServerException>()));
    });
  });

  group('signIn', () {
    const model = SignInModel(
      email: 'contato@devjonathancosta.com',
      passwd: '123456768',
    );

    test('should return map with tokens on success', () async {
      //arrange
      final response = json.decode(fixture("authetication/login_success.json"));
      when(mockHttpService.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      //act
      final result = await authDataSource.signIn(model);
      //assert
      expect(result, equals(isA<Map>()));
      expect(result?["access_token"], response["access_token"]);
    });

    test('should return internal fault when status code equals 400', () async {
      //arrange
      final response = json.decode(fixture("authetication/login_error.json"));
      when(mockHttpService.post(any, data: anyNamed('data'))).thenThrow(
        DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signIn;
      //assert
      expect(() async => await call(model), throwsA(isA<ServerException>()));
    });
  });

  group('currentUser', () {
    test('should return user data on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/current_user_success.json"));
      when(mockHttpService.get(any))
        .thenAnswer((_) async => Response(
          data: response,
          statusCode: 200,
          requestOptions: RequestOptions()
      ));
      //act
      final result = await authDataSource.currentUser();
      //assert
      expect(result, equals(isA<UserModel>()));
      expect(result?.name, equals(response["name"]));
    });

    test('should return a 400 error when there is a problem in the api', () async{
      //arrange
      final response = await json.decode(fixture("authetication/login_error.json"));
      when(mockHttpService.get(any)).thenThrow(
        DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions()
          )
        ),
      );
      //act
      final call = authDataSource.currentUser;
      //assert
      expect(() async => await call(), throwsA(isA<ServerException>()));
    });
  });

}
