import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

abstract class Logout {
  Future<Either<Failure, bool?>?> call();
}

class LogoutImpl implements Logout{

  final AuthRepository authRepository;
  LogoutImpl(this.authRepository);  

  @override
  Future<Either<Failure, bool?>?> call() async{
    return await authRepository.logout();
  }

}