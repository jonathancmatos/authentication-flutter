import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import '../../bootstrap/modular_test.dart';

class MockRegenerateAccessTokenImpl extends Mock implements RegenerateAccessTokenImpl {}

void main() {
  
  late DioHttpService dioHttpService;
  late Dio dio;
  late DioAdapter dioAdapter;

  const Map jsonRequest = {"data":true};

  setUpAll(() {
    Modular.init(TestModule());
    dio = Dio(BaseOptions(baseUrl: baseUrl));

    dioAdapter = DioAdapter(dio: dio);
    dioHttpService = DioHttpService(dio, testIgnore: true);
  });

  group('POST', () {
    test('should call method post correctly', () async {
      //arrange
      dioAdapter.onPost("/post", data: jsonRequest ,(server) 
        => server.reply(200, {}, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.post("/post", data: jsonRequest);
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method post failure', () async {
      //arrange
      dioAdapter.onPost("/post", data: jsonRequest, (server) => server.throws(
        401, DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: jsonRequest,
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        ),
      ));
      //assert
      await expectLater(dioHttpService.post("/post"),throwsA(isA<DioException>()));
    });
  });

  group('PUT', () {
    test('should call method put correctly', () async {
      //arrange
      dioAdapter.onPut("/put", data: jsonRequest, (server) 
        => server.reply(200, jsonRequest, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.put("/put", data: jsonRequest);
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method put failure', () async {
      //arrange
      dioAdapter.onPut("/put", data: jsonRequest, (server) => server.throws(
        401, DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: jsonRequest,
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        ),
      ));
      //assert
      await expectLater(dioHttpService.put("/put"),throwsA(isA<DioException>()));
    });
  });

  group('PATCH', () {
    test('should call method path correctly', () async {
      //arrange
      dioAdapter.onPatch("/patch", data: jsonRequest ,(server) 
        => server.reply(200, jsonRequest, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.patch("/patch", data: jsonRequest);
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method patch failure', () async {
      //arrange
      dioAdapter.onPatch("/patch", data: jsonRequest, (server) => server.throws(
        401, DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: jsonRequest,
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        ),
      ));
      //assert
      await expectLater(dioHttpService.patch("/patch"),throwsA(isA<DioException>()));
    });
  });

  group('GET', () {
    test('should call method get correctly', () async {
      //arrange
      dioAdapter.onGet("/get", (server) => server.reply(200, jsonRequest, 
        delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.get("/get");
      //assert
      expect(result.statusCode, equals(200));
    });

    test('should call method get failure', () async {
      //arrange
      dioAdapter.onGet("/get", (server) => server.throws(
        400, DioException(
          requestOptions: RequestOptions(),
          response: Response(
            data: {},
            statusCode: 400,
            requestOptions: RequestOptions(),
          ),
        )));
      //assert
      await expectLater(dioHttpService.get("/get"),throwsA(isA<DioException>()));
    });
  });

  group('DELETE', () {
    test('should call method delete correctly', () async {
      //arrange
      dioAdapter.onDelete("/delete", (server) 
        => server.reply(200, jsonRequest, delay: const Duration(seconds: 1)));
      //act
      final result = await dioHttpService.delete("/delete");
      //assert
      expect(result.statusCode, equals(200));
    });
    
    test('should call method delete failure', () async {
      //arrange
      dioAdapter.onDelete("/delete", (server) => server.throws(
        401, DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(),
          ),
        )));
      //assert
      await expectLater(dioHttpService.delete("/delete"),throwsA(isA<DioException>()));
    });
  });
  
}
