import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('failureInExeptionConverted function tests', () {
    test('Converts ServerFailure to Message', () {
      // arrange
      const failure =
          ServerFailure(type: 'ServerError', message: 'Internal server error');

      // act
      final result = failureInExeptionConverted(failure);

      // assert
      expect(result.title, equals('ServerError'));
      expect(result.text, equals('Internal server error'));
    });

    test('Converts NoConnectionFailure to Message', () {
      // arrange
      final failure = NoConnectionFailure();

      // act
      final result = failureInExeptionConverted(failure);

      // assert
      expect(result.title, equals('No Connection'));
      expect(result.text, equals('Sem Conexão com internet'));
    });

    test('Converts InternalFailure to Message', () {
      // arrange
      final failure = InternalFailure();

      // act
      final result = failureInExeptionConverted(failure);

      // assert
      expect(result.title, equals('Internal Error'));
      expect(result.text, equals('Houve um erro ao tentar realizar essa operação.'));
    });

    test('Converts unknown Failure to default Message', () {
      // arrange
      const unknownFailure = ServerFailure(message: 'Oops!', type: 'Algo deu errado.');

      // act
      final result = failureInExeptionConverted(unknownFailure);

      // assert
      expect(result.title, equals('Algo deu errado.'));
      expect(result.text, equals('Oops!'));
    });
  });

  group('leaveOnlyNumber', () {
    test('Removes non-numeric characters from the string', () {
      // arrange
      const input = 'a1b2c3d4';

      // act
      final result = leaveOnlyNumber(input);

      // assert
      expect(result, equals('1234'));
    });

    test('Handles an empty string', () {
      // arrange
      const input = '';

      // act
      final result = leaveOnlyNumber(input);

      // assert
      expect(result, equals(''));
    });

    test('Handles a string with no numeric characters', () {
      // arrange
      const input = 'abcd';

      // act
      final result = leaveOnlyNumber(input);

      // assert
      expect(result, equals(''));
    });

    test('Leaves the string unchanged if it contains only numeric characters',() {
      // arrange
      const input = '12345';

      // act
      final result = leaveOnlyNumber(input);

      // assert
      expect(result, equals('12345'));
    });

    test('Handles a string with spaces and special characters', () {
      // arrange
      const input = 'a 1 b ! 2 c 3 d @ 4';

      // act
      final result = leaveOnlyNumber(input);

      // assert
      expect(result, equals('1234'));
    });
  });
}
