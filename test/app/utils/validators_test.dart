import 'package:authentication_flutter/app/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateName', () {
    test('shoud return valid names', () {
      // arrange
      final validNames = ['John Doe', 'Alice Smith', 'Bob Johnson'];

      // act and assert
      for (final name in validNames) {
        expect(validateName(name), isTrue);
      }
    });

    test('should return invalid names', () {
      // arrange
      const invalidName = 'John';

      // act and assert
      expect(validateName(invalidName), isFalse);
    });
    
  });

  group('validateEmail', () {
    test('should return valid emails', () {
      // arrange
      final validEmails = ['test@example.com', 'user.email@domain.com', 'john.doe123@mail.co'];

      // act and assert
      for (final email in validEmails) {
        expect(validateEmail(email), isTrue);
      }
    });

    test('should return invalid emails', () {
      // Arrange
      final invalidEmails = ['test@.com', 'user@domain', 'invalid.email'];

      // act and assert
      for (final email in invalidEmails) {
        expect(validateEmail(email), isFalse);
      }
    });    
  });

  group('validatePasswd', () {
    test('should return valid passwords', () {
      // arrange
      final validPasswords = ['Passw0rd', 'StrongPassword123', 'Secure123!'];

      // act and assert
      for (final password in validPasswords) {
        expect(validatePasswd(password), isTrue);
      }
    });

    test('should return invalid passwords', () {
      // arrange
      final invalidPasswords = ['', 'short', 'onlylet', '1234567'];

      // act and assert
      for (final password in invalidPasswords) {
        expect(validatePasswd(password), isFalse);
      }
    });
  });

  group('validatePhone', () {
    test('should return valid phone numbers', () {
      // arrange
      final validPhones = ['(12) 94567-8901', '(98) 96543-2109', '(55) 91234-5678'];

      // act and assert
      for (final phone in validPhones) {
        expect(validatePhone(phone), isTrue);
      }
    });

    test('should return invalid phone numbers', () {
      // arrange
      final invalidPhones = ['123-456-7890', '(555) 1234-567', '(987) 65A3-2109'];

      // act and assert
      for (final phone in invalidPhones) {
        expect(validatePhone(phone), isFalse);
      }
    });
  });
}