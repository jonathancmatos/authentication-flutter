import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class SignInWithGoogle {
  Future<Either<Failure, bool?>?> call();
}

class SignInWithGoogleImpl implements SignInWithGoogle {
  final AuthRepository repository;
  SignInWithGoogleImpl(this.repository);

  @override
  Future<Either<Failure, bool?>?> call() async {
    return await repository.signInWithGoogle();
  }
}