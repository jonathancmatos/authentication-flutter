import 'package:authentication_flutter/app/core/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HashCode of two equal messages is the same', () {
    // arrange
    const  message1 = Message(title: 'Error', text: 'Oops!');
    const  message2 = Message(title: 'Error', text: 'Oops!');

    // assert
    expect(message1.hashCode, equals(message2.hashCode));
  });

  test('HashCode of two different messages is not the same', () {
    // arrange
    const message1 = Message(title: 'Error', text: 'Oops!');
    const message2 = Message(title: 'Success', text: 'Tudo certo!');

    // assert
    expect(message1.hashCode, isNot(equals(message2.hashCode)));
  });
}