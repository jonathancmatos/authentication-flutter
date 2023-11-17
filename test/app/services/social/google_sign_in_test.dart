import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/services/social/google_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn{}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

void main() {

  late MockGoogleSignIn googleSignIn;
  late GoogleAuthImpl googleAuthImpl;

  setUpAll((){
    googleSignIn = MockGoogleSignIn();
    googleAuthImpl = GoogleAuthImpl(googleSignIn);
  });

  group('SignIn', () {
    test('signIn should return GoogleSignInAccount on successful login', () async {
      // arrange
      final mockAccount = MockGoogleSignInAccount();
      when(() => googleSignIn.signIn()).thenAnswer((_) async => mockAccount);

      // act
      final result = await googleAuthImpl.signIn();

      // assert
      expect(result, mockAccount);
    });

    test('signIn should throw ServerException on user not found', () async {
      // arrange
      when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

      // assert
      expect(() => googleAuthImpl.signIn(), throwsA(isA<ServerException>()));
    });

    test('signIn should throw ServerException on failure', () async {
      // arrange
      when(() => googleSignIn.signIn()).thenThrow(Exception('Failed'));

      // assert
      expect(() => googleAuthImpl.signIn(), throwsA(isA<ServerException>()));
    });
  });

  group('Logout', () {
    test('logout should return true on successful logout', () async {
      // arrange
      when(() => googleSignIn.disconnect()).thenAnswer((_) async => null);

      // act
      final result = await googleAuthImpl.logout();

      // assert
      expect(result, true);
    });

    test('logout should throw ServerException on failure', () async {
      // arrange
      when(() => googleSignIn.disconnect()).thenThrow(Exception('Failed'));

      // assert
      expect(() => googleAuthImpl.logout(), throwsA(isA<ServerException>()));
    });
  });
  
}