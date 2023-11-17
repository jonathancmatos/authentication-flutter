import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/token_entity.dart';
import 'package:authentication_flutter/app/services/social/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../mocks/auth_mock.mocks.dart';

class MockGoogleAuth extends Mock implements GoogleAuthImpl {}

void main() {
  late MockDioHttpService mockHttpService;
  late AuthDataSourceImpl authDataSource;
  late MockGoogleAuth mockGoogleAuth;

  setUp(() {
    mockHttpService = MockDioHttpService();
    mockGoogleAuth = MockGoogleAuth();
    authDataSource = AuthDataSourceImpl(
      httpService: mockHttpService,
      googleAuth: mockGoogleAuth
    );
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
      final result = await authDataSource.signInWithEmail(model);
      //assert
      expect(result, equals(isA<TokenEntity>()));
      expect(result?.accessToken, response["access_token"]);
    });

    test('should return internal fault when status code equals 400', () async {
      //arrange
      final response = json.decode(fixture("authetication/login_with_email_error.json"));
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
      final call = authDataSource.signInWithEmail;
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
      final response = await json.decode(fixture("authetication/login_with_email_error.json"));
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

  group("logout", (){
    test('should return 200 on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/logout_success.json"));
      when(mockHttpService.post(any)).thenAnswer((_) async => Response(
        statusCode: 200,
        data: response,
        requestOptions: RequestOptions()
      ));
      //act
      final result = await authDataSource.logout();
      //assert
      expect(result, equals(true));
    });

    test('should return a 400 error [Server Exception]', () async{
      //arrange
      final response = await json.decode(fixture("authetication/logout_error.json"));
      when(mockHttpService.post(any)).thenThrow(
        DioError(
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));

      //act
      final call = authDataSource.logout;
      //assert
      expect(() async => await call(), throwsA(isA<ServerException>()));
    });
  });


  group('refreshToken',(){
    String refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2ODc4MzM3MjAsIm5iZiI6MTY4NzgzMzcyMCwiaXNzIjoibG9jYWxob3N0IiwidXNlcm5hbWUiOiJ0b2tlbml6YXRpb24iLCJleHAiOjE2ODc5MjAxMjAsImVtYWlsIjoiam9uYXRoYW5jb3N0YTQyOEBnbWFpbC5jb20ifQ.siwyueqXtifqGt38--d3GX9RPT5r_jzASOG8U0y1ZiFX--b8bpfjD443_cLaymz5SPS-mTO6jd_L82rExCRMEQ";
    
    test('should return 200 on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/refresh_token_success.json"));
      when(mockHttpService.post(any, data:anyNamed("data"))).thenAnswer((_) async => Response(
        statusCode: 200,
        data: response,
        requestOptions: RequestOptions()
      ));
      //act
      final result = await authDataSource.refreshAccessToken(refreshToken);
      //assert
      expect(result, isA<String>());
      expect(result, equals(response["response"]["message"]));
    });

    test('should return 401 failure on refresh token', () async{
      //arrange
      final response = await json.decode(fixture("authetication/refresh_token_error.json"));
      when(mockHttpService.post(any, data: anyNamed("data"))).thenThrow(
        DioError(
          response: Response(
            data: response,
            statusCode: 401,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));
      //act
      final call = authDataSource.refreshAccessToken;
      //assert
      expect(() async => await call(refreshToken), throwsA(isA<ServerException>()));
    });
  });
}
