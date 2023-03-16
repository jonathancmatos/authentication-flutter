import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = AccountModel(
      name: "Jonathan Costa",
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
      phone: "88992967878",
  );

  test('should be a subclass of New Account Entity', () {
    expect(model, isA<NewAccountEntity>());
  });

  test('should return a JSON map containing the proper data', () {
    //act
    final result = model.toJson();
    //assert
    final expectedJsonMap = {
      "name": "Jonathan Costa",
      "email": "contato@devjonathancosta.com",
      "passwd": "12345678",
      "phone": "88992967878"
    };
    expect(result, equals(expectedJsonMap));
  });
}
