import 'dart:convert';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:authentication_flutter/app/services/http/interceptors/my_http_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import '../../../fixtures/fixture_reader.dart';
import '../../bootstrap/modular_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late DioHttpService dioHttpService;
  late Dio dio;
  late DioAdapter dioAdapter;

  late SessionManager sessionManager;
  late UserManagerStore userManagerStore;
  late RegenerateAccessTokenImpl regenerateAccessToken;
  late String token;

  setUpAll(() {
    Modular.init(TestModule());
    userManagerStore = Modular.get<UserManagerStore>();
    sessionManager = Modular.get<SessionManager>();
    regenerateAccessToken = Modular.get<RegenerateAccessTokenImpl>();
    token = json.decode(fixture("authetication/login_success.json"))["access_token"];

    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async{
        await MyHttpInterceptor().onRequest(options);
        handler.next(options);
      },
      onResponse: (response, handler) async{
        await MyHttpInterceptor().onResponse(response);
        handler.next(response);
      },
      onError: (error, handler) async{
        await MyHttpInterceptor().onError(error);
        handler.next(error);
      }
    ));

    dioAdapter = DioAdapter(dio: dio);
    dioHttpService = DioHttpService(dio);
  });

  group('POST', () {
    const model = SignInModel(email: 'jonathancosta428@gmail.com', passwd: '12345678');

    test('should call method post correctly', () async {
      //arrange
      final response = fixture("authetication/login_success.json");
      when(() => sessionManager.getAccessToken()).thenAnswer((_) => token);
      dioAdapter.onPost("$baseUrl/signin", data: model.toJson() ,(server) => server.reply(200, {'data':response}, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.post("$baseUrl/signin", data: model.toJson());
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method post failure', () async {
      //arrange
      final response = fixture("authetication/login_with_email_error.json");
      when(() => userManagerStore.logoff(isExpiredToken: false)).thenAnswer((_) async => {});
      when(() => sessionManager.getAccessToken()).thenAnswer((_) => token);
      dioAdapter.onPost("$baseUrl/signin", data: model.toJson(), (server) => server.throws(
        401, DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        ),
      ));
      //assert
      await expectLater(dio.post("$baseUrl/signin"),throwsA(isA<DioError>()));
      verifyNever(() => userManagerStore.logoff(isExpiredToken: false));
    });
  });


  group('GET', () {

    test('should call method get correctly', () async {
      //arrange
      final response = await json.decode(fixture("authetication/login_success.json"));
      when(() => sessionManager.getAccessToken()).thenAnswer((_) => token);
      dioAdapter.onGet("$baseUrl/current-user", (server) => server.reply(200, {'data':response}, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.get("$baseUrl/current-user");
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method get failure', () async {
      //arrange
      final response = await json.decode(fixture("authetication/current_user_error.json"));
      when(() => userManagerStore.logoff(isExpiredToken: true)).thenAnswer((_) async => {});
      when(() => sessionManager.getAccessToken()).thenAnswer((_) => token);
      when(() => regenerateAccessToken.call()).thenAnswer((_) async => Left(InternalFailure()));
      dioAdapter.onGet("$baseUrl/current-user", (server) => server.throws(
        401, DioError(
          requestOptions: RequestOptions(),
          response: Response(
            data: response,
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        )));
      //assert
      await expectLater(dio.get("$baseUrl/current-user"),throwsA(isA<DioError>()));
      verify(() => userManagerStore.logoff(isExpiredToken: true));
    });
  });
}
