import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class NewAccount {
  Future<Either<Failure, bool?>?> call(NewAccountEntity account);
}

class NewAccountImpl extends NewAccount {
  final AuthRepository repository;
  NewAccountImpl(this.repository);

  @override
  Future<Either<Failure, bool?>?> call(NewAccountEntity account) async {
    return await repository.signUp(account);
  }
}
