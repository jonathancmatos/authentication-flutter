import 'package:authentication_flutter/app/core/error/entities/error_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HashCode of two equal error responses is the same', () {
    // arrange
    const errorResponse1 = ErrorResponse(code: 404, type: 'Not Found', message: 'Resource not found');
    const errorResponse2 = ErrorResponse(code: 404, type: 'Not Found', message: 'Resource not found');

    // assert
    expect(errorResponse1.hashCode, equals(errorResponse2.hashCode));
  });

  test('HashCode of two different error responses is not the same', () {
    // arrange
    const errorResponse1 = ErrorResponse(code: 404, type: 'Not Found', message: 'Resource not found');
    const errorResponse2 = ErrorResponse(code: 500, type: 'Internal Server Error', message: 'Server error');

    // assert
    expect(errorResponse1.hashCode, isNot(equals(errorResponse2.hashCode)));
  });
}