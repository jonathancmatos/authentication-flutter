import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class RegenerateAccessToken {
  Future<Either<Failure, bool?>?> call();
}

class RegenerateAccessTokenImpl implements RegenerateAccessToken {
  final AuthRepository repository;
  RegenerateAccessTokenImpl(this.repository);

  @override
  Future<Either<Failure, bool?>?> call() async {
    return await repository.refreshAccessToken();
  }
}
