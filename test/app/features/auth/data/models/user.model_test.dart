import 'dart:convert';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
  late UserModel model;

  setUp((){
    final response = fixture("authetication/current_user_success.json");
    model = UserModel.fromJson(json.decode(response));
  });

  test("should be a subclass of User Entitty", (){
    //assert
    expect(model, isA<UserEntity>());
  });

  test("should conveted a map into an object", (){
    //assert
    expect(model.name, equals("Jonathan Costa"));
  });

  test("should return a JSON map containing the proper data", (){
    //act
    final result = model.toJson();
    //assert
    final expectedJsonMap = {
      "name":"Jonathan Costa",
      "email":"contato@devjonathancosta.com",
      "phone":"88992967878",
      "google_id": ""
    };
    expect(result, equals(expectedJsonMap));
  });
}