import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late SignInWithEmail usecase;
  late MockAuthRepository mockAuthRepository;
  late SignInEntity signIn;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithEmailImpl(mockAuthRepository);
    signIn = const SignInEntity(
      email: "contato@devjonathancosta.com",
      passwd: "12345678",
    );
  });

  test('Should get bool when logging in to repository', () async {
    //arrannge
    when(mockAuthRepository.signIn(signIn))
        .thenAnswer((_) async => const Right(true));
    //act
    var result = await usecase.call(signIn);
    //assert
    expect(result, equals(isA<Right>()));
    verify(mockAuthRepository.signIn(signIn));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
