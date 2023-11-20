import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/states/signup_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';


class MockNewAccount extends Mock implements NewAccountImpl {}

void main() {

  late SignUpStore signUpStore;
  late MockNewAccount mockNewAccount;

  setUpAll((){
    WidgetsFlutterBinding.ensureInitialized();
    mockNewAccount = MockNewAccount();
    signUpStore = SignUpStore(mockNewAccount);

    signUpStore.setName('John Doe');
    signUpStore.setEmail('contato@johndoe.com.br');
    signUpStore.setPasswd('12345678');
    signUpStore.setConfirmPasswd('12345678');
    signUpStore.setPhone('');
  });

  test('The initial state must return false', (){
    //act and assert
    expect(signUpStore.isLoading, equals(false));
  });

  test('must return true when validating the name property', (){
    //act and assert
    expect(signUpStore.name, 'John Doe');
    expect(signUpStore.nameValidator, isNull);
  });

  test('must return true when validating the email property', (){
    //act and assert
    expect(signUpStore.email, 'contato@johndoe.com.br');
    expect(signUpStore.emailValidator, isNull);
  });

  test('must return true when validating the password property', (){
    //act and assert
    expect(signUpStore.passwd, '12345678');
    expect(signUpStore.confirmPasswd, '12345678');
    expect(signUpStore.passwd, equals(signUpStore.confirmPasswd));
    expect(signUpStore.passwdValidator, isNull);
    expect(signUpStore.passwdConfirmValidator, isNull);
  });

  test('must return false when validating the phone property', (){
    //act and assert
    expect(signUpStore.phoneValidator, isNull);
  });

  test('should call _onSuccess when signUp is successful', () async {
    //arrange
    const entity = NewAccountEntity(
      name: 'John Doe',
      email: 'contato@johndoe.com.br',
      passwd: '12345678',
      phone: '');
    when(() => mockNewAccount.call(entity)).thenAnswer((_) async => const Right(null));

    //act
    await signUpStore.signUp(onSuccess: (){}, onFailure: (message){});

    //assert
    expect(signUpStore.isLoading, false);
  });

  test('should call _onFailure when signUp fails', () async {
    // arrange
    const entity = NewAccountEntity(
      name: 'John Doe',
      email: 'contato@johndoe.com.br',
      passwd: '12345678',
      phone: '');
    when(() => mockNewAccount.call(entity)).thenAnswer((_) async 
      => const Left(ServerFailure(type: 'Error', message: 'Server error')));

    // act
    await signUpStore.signUp(onSuccess: (){}, onFailure: (message){});

    // assert
    expect(signUpStore.isLoading, false);
  });
 
}