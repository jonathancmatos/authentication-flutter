import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late RegenerateAccessToken usercase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usercase = RegenerateAccessTokenImpl(repository);
  });

  test('should return true when calling the refresh token method', () async {
    //arrange
    when(repository.refreshAccessToken()).thenAnswer((_) async => const Right(true));
    //act
    final result = await usercase.call();
    //assert
    expect(result, equals(isA<Right>()));
    verify(repository.refreshAccessToken());
    verifyNoMoreInteractions(repository);
  });
}
