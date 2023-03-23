import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = SignInModel(
    email: "contato@devjonathancosta.com",
    passwd: "12345678",
  );

  test('should be a subclass of Sign In Entity', () {
    expect(model, isA<SignInEntity>());
  });

  test('should return a JSON map containing the proper data', () {
    //act
    final result = model.toJson();
    //assert
    final expectedJsonMap = {
      "email": "contato@devjonathancosta.com",
      "passwd": "12345678"
    };
    expect(result, equals(expectedJsonMap));
  });
}
