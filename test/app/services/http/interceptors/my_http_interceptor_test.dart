import 'dart:convert';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/http/http_service.dart';
import 'package:authentication_flutter/app/services/http/interceptors/my_http_interceptor.dart';
import 'package:authentication_flutter/app/services/http/unauthorized_request_retrier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../fixtures/fixture_reader.dart';
import '../../../bootstrap/modular_test.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {

  late MyHttpInterceptor myHttpInterceptor;
  late MockHttpService mockHttpService;

  setUpAll(() {
    Modular.init(TestModule());
    
    myHttpInterceptor = MyHttpInterceptor();
    mockHttpService = MockHttpService();
  });


  test('should call _generateAccessToken on token_expired error', () async {
    // arrange
    final responseError = await json.decode(fixture("authetication/current_user_error.json"));
    final errorResponse = DioException(
      requestOptions: RequestOptions(path: '/example'),
      response: Response(
        data: responseError,
        statusCode: 401,
        requestOptions: RequestOptions(path: '/example'),
      ),
    );

    final responseSuccess = await json.decode(fixture("authetication/current_user_success.json"));
    final successResponse = Response(
      statusCode: 200,
      requestOptions: RequestOptions(
        path: errorResponse.requestOptions.path,
        data: responseSuccess,
        method: errorResponse.requestOptions.method,
      )
    );

    when(() => mockHttpService.get('/example')).thenThrow((_) async => 
      DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          data: responseError,
          statusCode: 401,
          requestOptions: RequestOptions(),
        ),
    ));

    when(() => Modular.get<RegenerateAccessTokenImpl>().call())
      .thenAnswer((_) async => const Right(true));

    when(() => Modular.get<UnauthorizedRequestRetrierImpl>().retry(
      options: any(named: 'options'),
      retryIf: any(named: 'retryIf'),
    )).thenAnswer((_) async => successResponse);

    // act
    await myHttpInterceptor.onError(errorResponse, ((result) => result));

    // assert
    verifyNever((() => Modular.get<UserManagerStore>().logoff(isExpiredToken: true)));
  });

  test('should return failure when call _generateAccessToken', () async {
    // arrange
    final response = await json.decode(fixture("authetication/current_user_error.json"));
    final errorResponse = DioException(
      requestOptions: RequestOptions(path: '/example'),
      response: Response(
        data: response,
        statusCode: 401,
        requestOptions: RequestOptions(path: '/example'),
      ),
    );

    when(() => mockHttpService.get('/example')).thenThrow((_) async => 
      DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(),
        response: Response(
          data: response,
          statusCode: 401,
          requestOptions: RequestOptions(),
        ),
    ));
    when(() => Modular.get<RegenerateAccessTokenImpl>().call())
      .thenAnswer((_) async => Left(NoConnectionFailure())); 
    when(() => Modular.get<UserManagerStore>().logoff(isExpiredToken: true))
      .thenAnswer((_) async => const Right(true));    

    // act
    await myHttpInterceptor.onError(errorResponse, ((result) => null));

    // assert
    verify(() => Modular.get<UserManagerStore>().logoff(isExpiredToken: true));
  });
  
}