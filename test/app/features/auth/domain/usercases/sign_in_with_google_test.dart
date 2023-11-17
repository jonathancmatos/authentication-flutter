import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_google.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepositoryImpl extends Mock implements AuthRepository {}

void main() {

  late MockAuthRepositoryImpl repository;
  late SignInWithGoogle usercase;

  setUpAll((){ 
    repository = MockAuthRepositoryImpl();
    usercase = SignInWithGoogleImpl(repository);
  });

  test('Should get bool when logging with google in to repository', () async {
    //arrannge
    when(() => repository.signInWithGoogle()).thenAnswer((_) async => const Right(true));
    //act
    var result = await usercase.call();
    //assert
    expect(result, equals(isA<Right>()));
    verify(() => repository.signInWithGoogle());
    verifyNoMoreInteractions(repository);
  });

}