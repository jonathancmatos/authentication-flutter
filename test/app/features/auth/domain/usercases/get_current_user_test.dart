import 'dart:convert';
import 'package:authentication_flutter/app/features/auth/data/models/user.model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../../../../fixtures/fixture_reader.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late GetCurrentUser usercase;
  late MockAuthRepository repository;
  late UserEntity entity;

  setUp((){
    repository = MockAuthRepository();
    usercase = getCurrentUserImpl(repository);
  });

  test("should return the data of the logged in user", () async{
    //arrange
    final response = fixture("authetication/current_user_success.json");
    entity =  UserModel.fromJson(json.decode(response));
    when(repository.currentUser()).thenAnswer((_) async =>  Right(entity));
    //act
    final result = await usercase.call();
    //assert
    expect(result, equals(isA<Right>()));
    verify(repository.currentUser());
    verifyNoMoreInteractions(repository);
  });
}