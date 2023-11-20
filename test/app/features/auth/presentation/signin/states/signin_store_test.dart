import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_email.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_google.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signin/states/signin_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInWithEmail extends Mock implements SignInWithEmailImpl {}
class MockSignInWithGoogle extends Mock implements SignInWithGoogleImpl {}

void main() {
  late SignInStore signInStore;
  late MockSignInWithEmail mockSignInWithEmail;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late SignInEntity signInEntity;

  setUpAll((){
    mockSignInWithEmail = MockSignInWithEmail();
    mockSignInWithGoogle = MockSignInWithGoogle();
    signInStore = SignInStore(
      signInWithEmail: mockSignInWithEmail,
      signInWithGoogle: mockSignInWithGoogle,
    );
  });

  test('should validate email properly', () {
    // arrange
    signInStore.setEmail('invalidemail'); 

    // act
    final result = signInStore.emailValidator;

    // assert
    expect(result, isNotNull);
  });

  test('should validate password properly', () {
    // arrange
    signInStore.setPasswd(''); // Invalid password

    // act
    final result = signInStore.passwdValidator;

    // assert
    expect(result, isNotNull);
  });

  group('signInWithEmail', () {
    signInEntity = const SignInEntity(email: 'john@example.com', passwd: 'password123');

    test('should call onSuccess when signInWithEmail succeeds', () async {
      //arrange
      signInStore.setEmail('john@example.com');
      signInStore.setPasswd('password123');
      when(() => mockSignInWithEmail.call(signInEntity)).thenAnswer((_) async => const Right(null));

      // act
      await signInStore.signIn(
        onSuccess: () {
          //assert
          expect(signInStore.isLoading, isFalse);
        },
        onError: (_) {},
        isSignSocial: false,
      );

      //verify
      verifyNever(() => mockSignInWithGoogle.call());
    });

    test('should call onError when signInWithEmail fails', () async {
      //arrange
      signInStore.setEmail('john@example.com');
      signInStore.setPasswd('password123');
      when(() => mockSignInWithEmail.call(signInEntity)).thenAnswer((_) async 
        => const Left(ServerFailure(type: 'Error', message: 'Invalid credentials')));

      //act
      await signInStore.signIn(
        onSuccess: () {},
        onError: (message) {
          //assert
          expect(message, equals(const Message(title: 'Error', text: 'Invalid credentials')));
        },
        isSignSocial: false,
      );

      //verify
      verifyNever(() => mockSignInWithGoogle.call());
    });
  });

  group('signInWithGoogle', () {
    test('should call onSuccess when signInWithGoogle succeeds', () async {
      //arrange
      when(() => mockSignInWithGoogle.call()).thenAnswer((_) async => const Right(null));

      //act
      await signInStore.signIn(
        onSuccess: () {
          //assert
          expect(signInStore.isLoading, isFalse);
        },
        onError: (_) {},
        isSignSocial: true,
      );

      //verify
      verify(() => mockSignInWithGoogle.call());
    });

    test('should call onError when signInWithGoogle fails', () async {
      //arrange
      when(() => mockSignInWithGoogle.call()).thenAnswer((_) async =>
        const Left(ServerFailure(type: 'Error', message: 'Google sign-in failed')));

      //act
      await signInStore.signIn(
        onSuccess: () {},
        onError: (message) {
          // Assert
          expect(message, equals(const Message(title: 'Error', text: 'Google sign-in failed')));
        },
        isSignSocial: true,
      );

      //verify
      verify(() => mockSignInWithGoogle.call());
    });

  });
}