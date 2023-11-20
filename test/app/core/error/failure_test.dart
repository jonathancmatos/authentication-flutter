import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ServerFailure properties are set correctly', () {
    // arrange
    const serverFailure = ServerFailure(type: 'ServerError', message: 'Internal server error');

    // assert
    expect(serverFailure.type, equals('ServerError'));
    expect(serverFailure.message, equals('Internal server error'));
  });

  test('InternalFailure instances are equal', () {
    // arrange
    final internalFailure1 = InternalFailure();
    final internalFailure2 = InternalFailure();

    // assert
    expect(internalFailure1, equals(internalFailure2));
  });

  test('NoConnectionFailure instances are equal', () {
    // Arrange
    final noConnectionFailure1 = NoConnectionFailure();
    final noConnectionFailure2 = NoConnectionFailure();

    // Assert
    expect(noConnectionFailure1, equals(noConnectionFailure2));
  });
}