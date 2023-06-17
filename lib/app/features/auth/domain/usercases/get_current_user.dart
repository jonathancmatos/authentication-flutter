import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class GetCurrentUser{
  Future<Either<Failure, UserEntity?>?> call();
}

class GetCurrentUserImpl implements GetCurrentUser{

  final AuthRepository authRepository;
  GetCurrentUserImpl(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>?> call() async{
    return await authRepository.currentUser();
  }
}