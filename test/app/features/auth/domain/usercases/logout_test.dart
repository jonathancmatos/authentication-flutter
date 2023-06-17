import 'package:authentication_flutter/app/features/auth/domain/usercases/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/auth_mock.mocks.dart';

void main() {
  late Logout usercase; 
  late MockAuthRepository repository;

  setUp((){
    repository = MockAuthRepository();
    usercase = LogoutImpl(repository);
  });

  test('should return true when calling the logout method', () async{
    //arrange
    when(repository.logout()).thenAnswer((_) async => const Right(true));
    //act
    final result = await usercase.call();
    //assert
    expect(result, equals(isA<Right>()));
    verify(repository.logout());
    verifyNoMoreInteractions(repository);
  });

}