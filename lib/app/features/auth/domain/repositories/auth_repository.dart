import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>>? signUp(NewAccountEntity account);
  Future<Either<Failure, bool>>? signIn(SignInEntity signIn);
}
