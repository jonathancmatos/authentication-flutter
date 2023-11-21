import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/token_entity.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:authentication_flutter/app/services/social/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../../../bootstrap/modular_test.dart';

class MockDioHttpService extends Mock implements DioHttpService {}
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
    Modular.init(TestModule());
    const model = AccountModel(
      name: "Jonathan Costa",
      email: "contato@devjonathan.com",
      passwd: "12345678",
      phone: "88996770054");

    test('should return true when registering a new user ', () async {
      //arrange
      final response = await json.decode(fixture("authetication/created_account_success.json"));
      when(() => mockHttpService.post('/signup', data: any(named: 'data')))
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

    test('should return ServerException when registering a new user ', () async {
      //arrange
      final response = await json.decode(fixture("authetication/created_account_error.json"));
      when(() => mockHttpService.post('/signup', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
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

    test('should return NoConnectionException when registering a new user ', () async {
      //arrange
      when(() => mockHttpService.post('/signup', data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400, 
            requestOptions:  RequestOptions()
          ),
          type: DioExceptionType.connectionTimeout, 
          requestOptions: RequestOptions()),
      );
      //act
      final call = authDataSource.signUp;
      //assert
      expect(() async => await call(model), throwsA(isA<NoConnectionException>()));
    });

    test('should return InternalException when registering a new user ', () async {
      //arrange
      when(() => mockHttpService.post('/signup', data: any(named: 'data'))).thenThrow(
        DioException(
          response: Response(
            statusCode: 400, 
            requestOptions:  RequestOptions()
          ),
          type: DioExceptionType.unknown, 
          requestOptions: RequestOptions()),
      );
      //act
      final call = authDataSource.signUp;
      //assert
      expect(() async => await call(model), throwsA(isA<InternalException>()));
    });
  });

  group('signInWithEmail', () {
    const model = SignInModel(
      email: 'contato@devjonathancosta.com',
      passwd: '123456768',
    );

    test('should return map with tokens on success', () async {
      //arrange
      final response = json.decode(fixture("authetication/login_success.json"));
      when(() => mockHttpService.post('/signin', data: any(named: 'data')))
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

    test('should return ServerException when status code equals 400', () async {
      //arrange
      final response = json.decode(fixture("authetication/login_with_email_error.json"));
      when(() => mockHttpService.post('/signin', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
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

    test('must return NoConnectionException when returning map with tokens', () async {
      //arrange
      when(() => mockHttpService.post('/signin', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signInWithEmail;
      //assert
      expect(() async => await call(model), throwsA(isA<NoConnectionException>()));
    });

    test('must return InternalException when returning map with tokens', () async {
      //arrange
      when(() => mockHttpService.post('/signin', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signInWithEmail;
      //assert
      expect(() async => await call(model), throwsA(isA<InternalException>()));
    });
  });

  group('signInWithGoogle', () {
    test('should return map with tokens on success', () async {
      //arrange
      when(() => mockGoogleAuth.signIn()).thenAnswer((_) async => null);
      final response = json.decode(fixture("authetication/login_success.json"));
      when(() => mockHttpService.post('/google-sign-in', data: any(named: 'data')))
        .thenAnswer((_) async => Response(
          data: response,
          statusCode: 200,
          requestOptions: RequestOptions(),
      ));
      //act
      final result = await authDataSource.signInWithGoogle();
      //assert
      expect(result, equals(isA<TokenEntity>()));
      expect(result?.accessToken, response["access_token"]);
    });

    test('should return ServerException when status code equals 400', () async {
      //arrange
      when(() => mockGoogleAuth.signIn()).thenAnswer((_) async => null);
      final response = json.decode(fixture("authetication/login_with_email_error.json"));
      when(() => mockHttpService.post('/google-sign-in', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signInWithGoogle;
      //assert
      expect(() async => await call(), throwsA(isA<ServerException>()));
    });

    test('must return NoConnectionException when returning map with tokens', () async {
      //arrange
      when(() => mockGoogleAuth.signIn()).thenAnswer((_) async => null);
      when(() => mockHttpService.post('/google-sign-in', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signInWithGoogle;
      //assert
      expect(() async => await call(), throwsA(isA<NoConnectionException>()));
    });

    test('must return InternalException when returning map with tokens', () async {
      //arrange
      when(() => mockGoogleAuth.signIn()).thenAnswer((_) async => null);
      when(() => mockHttpService.post('/google-sign-in', data: any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        ),
      );
      //act
      final call = authDataSource.signInWithGoogle;
      //assert
      expect(() async => await call(), throwsA(isA<InternalException>()));
    });
  });
  
  group('currentUser', () {
    test('should return user data on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/current_user_success.json"));
      when(() => mockHttpService.get('/current-user'))
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

    test('should return ServerException when there is a problem in the api', () async{
      //arrange
      final response = await json.decode(fixture("authetication/current_user_error.json"));
      when(() => mockHttpService.get('/current-user')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
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

    test('should return NoConnectionException when return user data', () async{
      //arrange
      when(() => mockHttpService.get('/current-user')).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions()
          )
        ),
      );
      //act
      final call = authDataSource.currentUser;
      //assert
      expect(() async => await call(), throwsA(isA<NoConnectionException>()));
    });

    test('should return InternalException when return user data', () async{
      //arrange
      when(() => mockHttpService.get('/current-user')).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions()
          )
        ),
      );
      //act
      final call = authDataSource.currentUser;
      //assert
      expect(() async => await call(), throwsA(isA<InternalException>()));
    });
  });

  group("logout", (){
    test('should return 200 on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/logout_success.json"));
      when(() => mockHttpService.post('/logout')).thenAnswer((_) async => Response(
        statusCode: 200,
        data: response,
        requestOptions: RequestOptions()
      ));
      //act
      final result = await authDataSource.logout();
      //assert
      expect(result, equals(true));
    });

    test('should return a 400 error [ServerException]', () async{
      //arrange
      final response = await json.decode(fixture("authetication/logout_error.json"));
      when(() => mockHttpService.post('/logout')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
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

    test('should return NoConnectionException', () async{
      //arrange
      when(() => mockHttpService.post('/logout')).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));

      //act
      final call = authDataSource.logout;
      //assert
      expect(() async => await call(), throwsA(isA<NoConnectionException>()));
    });

    test('should return InternalException', () async{
      //arrange
      when(() => mockHttpService.post('/logout')).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));

      //act
      final call = authDataSource.logout;
      //assert
      expect(() async => await call(), throwsA(isA<InternalException>()));
    });
  });

  group('refreshToken',(){
    String refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2ODc4MzM3MjAsIm5iZiI6MTY4NzgzMzcyMCwiaXNzIjoibG9jYWxob3N0IiwidXNlcm5hbWUiOiJ0b2tlbml6YXRpb24iLCJleHAiOjE2ODc5MjAxMjAsImVtYWlsIjoiam9uYXRoYW5jb3N0YTQyOEBnbWFpbC5jb20ifQ.siwyueqXtifqGt38--d3GX9RPT5r_jzASOG8U0y1ZiFX--b8bpfjD443_cLaymz5SPS-mTO6jd_L82rExCRMEQ";
    
    test('should return 200 on success', () async{
      //arrange
      final response = await json.decode(fixture("authetication/refresh_token_success.json"));
      when(() => mockHttpService.post('/refresh-token', data:any(named: 'data'))).thenAnswer((_) async => Response(
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

    test('should return ServerException when refresh token', () async{
      //arrange
      final response = await json.decode(fixture("authetication/refresh_token_error.json"));
      when(() => mockHttpService.post('/refresh-token', data:any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
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

    test('should return NoConnectionException when refresh token', () async{
      //arrange
      when(() => mockHttpService.post('/refresh-token', data:any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));
      //act
      final call = authDataSource.refreshAccessToken;
      //assert
      expect(() async => await call(refreshToken), throwsA(isA<NoConnectionException>()));
    });

    test('should return InternalException when refresh token', () async{
      //arrange
      when(() => mockHttpService.post('/refresh-token', data:any(named: 'data'))).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions()
          ),
          requestOptions: RequestOptions()
      ));
      //act
      final call = authDataSource.refreshAccessToken;
      //assert
      expect(() async => await call(refreshToken), throwsA(isA<InternalException>()));
    });
  });
}
