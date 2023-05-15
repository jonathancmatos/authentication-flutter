import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:authentication_flutter/app/services/http/interceptors/my_http_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Interceptor])

void main() {
  const String baseUrl = "https://jsonplaceholder.typicode.com";

  late DioHttpService dioHttpService;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
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

  test('should call method post correctly', () async {
    //arrange
    const testUrl = '$baseUrl/posts';
    const data = {'title': 'foo', 'body': 'bar', 'userId': 1};
    dioAdapter.onPost(testUrl, data:data ,(server) => server.reply(200, {'data':{}}, delay: const Duration(seconds: 1)));
    //act
    final result = await dioHttpService.post(testUrl, data: data);
    //assert
    expect(result.statusCode, equals(200));
  });

  test('should call method get correctly', () async {
    //arrange
    const url = "$baseUrl/todos/1";
    dioAdapter.onGet(url, (server) => server.reply(200, {'data':{}}, delay: const Duration(seconds: 1)));
    //act
    final result = await dioHttpService.get(url);
    //assert
    expect(result.statusCode, equals(200));
  });
}
