import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late NewAccount usercase;
  late MockAuthRepository mockAuthRepository;
  late NewAccountEntity entity;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usercase = NewAccountImpl(mockAuthRepository);
    entity = const NewAccountEntity(
      name: "Jonathan Costa",
      email: "contato@devjonathancosta.com",
      passwd: "123456",
      phone: "88992567799",
    );
  });

  test('should get bool when sending a new record to the repository', () async {
    //arrange
    when(mockAuthRepository.signUp(entity))
        .thenAnswer((_) async => const Right(true));
    //act
    var result = await usercase(entity);
    //assert
    expect(result, equals(isA<Right>()));
    verify(mockAuthRepository.signUp(entity));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
