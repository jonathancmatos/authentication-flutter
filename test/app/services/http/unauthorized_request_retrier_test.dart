import 'package:authentication_flutter/app/services/http/unauthorized_request_retrier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'interceptors/my_http_interceptor_test.dart';

void main() {
  late UnauthorizedRequestRetrierImpl retrier;
  late MockHttpService mockHttpService;

  setUp(() {
    mockHttpService = MockHttpService();
    retrier = UnauthorizedRequestRetrierImpl(mockHttpService);
  });

  test('should retry a POST request', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'POST', data: {'key': 'value'});
    when(() => mockHttpService.post('/example', data: {'key': 'value'})).thenAnswer((_) async => 'response');

    // act
    final result = await retrier.retry(options: options);

    // assert
    expect(result, 'response');
    verify(() => mockHttpService.post('/example', data: {'key': 'value'})).called(1);
  });

  test('should retry a GET request', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'GET');
    when(() => mockHttpService.get('/example')).thenAnswer((_) async => 'response');

    // act
    final result = await retrier.retry(options: options);

    // assert
    expect(result, 'response');
    verify(() => mockHttpService.get('/example')).called(1);
  });

  test('should retry a PUT request', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'PUT', data: {'key': 'value'});
    when(() => mockHttpService.put('/example', data: {'key': 'value'})).thenAnswer((_) async => 'response');

    // act
    final result = await retrier.retry(options: options);

    // assert
    expect(result, 'response');
    verify(() => mockHttpService.put('/example', data: {'key': 'value'})).called(1);
  });

  test('should retry a DELETE request', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'DELETE');
    when(() => mockHttpService.delete('/example')).thenAnswer((_) async => 'response');

    // act
    final result = await retrier.retry(options: options);

    // assert
    expect(result, 'response');
    verify(() => mockHttpService.delete('/example')).called(1);
  });

  test('should retry a PATCH request', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'PATCH', data: {'key': 'value'});
    when(() => mockHttpService.patch('/example', data: {'key': 'value'})).thenAnswer((_) async => 'response');

    // act
    final result = await retrier.retry(options: options);

    // assert
    expect(result, 'response');
    verify(() => mockHttpService.patch('/example', data: {'key': 'value'})).called(1);
  });

  test('should throw an exception for an invalid request method', () async {
    // arrange
    final options = RequestOptions(path: '/example', method: 'INVALID_METHOD');

    // act & assert
    expect(() => retrier.retry(options: options), throwsException);
    verifyZeroInteractions(mockHttpService); 
  });
}