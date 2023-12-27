import 'dart:convert';
import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('ServerException properties are set correctly', () async{
    // arrange
    Response response = Response(data: json.decode(errorResponse), requestOptions: RequestOptions());
    var serverException = ServerException.fromData(response);

    // assert
    expect(serverException, isA<ServerException>());
  });

  test('ServerException properties are set correctly', () {
    // arrange
    const serverException = ServerException(
      type: 'Error',
      message: 'Error Server'
    );

    // assert
    expect(serverException, isA<ServerException>());
    expect(serverException.code, equals(00));
  });

  test('InternalException is an Exception', () {
    // assert
    expect(() => throw InternalException(), throwsException);
  });

  test('NoConnectionException is an Exception', () {
    // assert
    expect(() => throw NoConnectionException(), throwsException);
  });
}

String errorResponse = '''
{
    "response": {
        "type": "unauthorized",
        "message": "Signature verification failed"
    }
}
''';