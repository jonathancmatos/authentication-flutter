import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class SignInWithEmail {
  Future<Either<Failure, bool?>?> call(SignInEntity signIn);
}

class SignInWithEmailImpl implements SignInWithEmail {
  final AuthRepository repository;
  SignInWithEmailImpl(this.repository);

  @override
  Future<Either<Failure, bool?>?> call(SignInEntity signIn) async {
    return await repository.signIn(signIn);
  }
}
