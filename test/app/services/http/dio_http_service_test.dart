import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dio_http_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  const String baseUrl = "https://jsonplaceholder.typicode.com";

  late DioHttpService dioHttpService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dioHttpService = DioHttpService(mockDio);
  });

  test('should call method post correctly', () async {
    //arrange
    const testUrl = '$baseUrl/posts';
    const data = {'title': 'foo', 'body': 'bar', 'userId': 1};
    //act
    await dioHttpService.post(testUrl, data: data);
    //assert
    verify(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')));
  });

  test('should call method get correctly', () async {
    //arrange
    const url = "$baseUrl/todos/1";
    //act
    await dioHttpService.get(url);
    //assert
    verify(mockDio.get(any, options: anyNamed('options')));
  });
}
