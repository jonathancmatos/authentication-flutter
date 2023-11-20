import 'package:authentication_flutter/app/features/auth/domain/entities/token_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create TokenEntity with correct properties', () {
    // arrange
    const accessToken = 'access_token';
    const refreshToken = 'refresh_token';

    // act
    const tokenEntity =
        TokenEntity(accessToken: accessToken, refreshToken: refreshToken);

    // assert
    expect(tokenEntity.accessToken, equals(accessToken));
    expect(tokenEntity.refreshToken, equals(refreshToken));
  });

  test('should have correct equality', () {
    // arrange
    const tokenEntity1 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity2 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity3 =
        TokenEntity(accessToken: 'token2', refreshToken: 'refresh2');

    // act & assert
    expect(tokenEntity1, equals(tokenEntity2)); // Equality for equal objects
    expect(tokenEntity1 == tokenEntity3,
        isFalse); // Inequality for different objects
  });

  test('should have correct hashCode', () {
    // arrange
    const tokenEntity1 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity2 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity3 =
        TokenEntity(accessToken: 'token2', refreshToken: 'refresh2');

    // act & assert
    expect(tokenEntity1.hashCode,
        equals(tokenEntity2.hashCode)); // HashCode for equal objects
    expect(tokenEntity1.hashCode == tokenEntity3.hashCode,
        isFalse); // HashCode for different objects
  });

  test('should implement Equatable', () {
    // arrange
    const tokenEntity1 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity2 =
        TokenEntity(accessToken: 'token1', refreshToken: 'refresh1');
    const tokenEntity3 =
        TokenEntity(accessToken: 'token2', refreshToken: 'refresh2');

    // act & assert
    expect(tokenEntity1, isA<Equatable>());
    expect(tokenEntity1 == tokenEntity2, isTrue);
    expect(tokenEntity1 == tokenEntity3, isFalse);
  });
}
