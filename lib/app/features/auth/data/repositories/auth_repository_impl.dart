import 'dart:io';

import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  AuthDataSource dataSource;
  AuthRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, bool>>? signUp(NewAccountEntity account) async {
    final isConnected = await _checkNetworkConnected();
    return isConnected.fold(
      (failure) => Left(NoConnectionFailure()),
      (success) async {
        try {
          final model = AccountModel(
            name: account.name,
            email: account.email,
            passwd: account.passwd,
            phone: account.phone,
          );

          final result = await dataSource.signUp(model);
          return Right(result!);
        } on InternalException {
          return Left(InternalFailure());
        } on ServerException {
          return Left(ServerFailure());
        } on NoConnectionException {
          return Left(NoConnectionFailure());
        }
      },
    );
  }

  Future<Either<Failure, bool>> _checkNetworkConnected() async {
    if (!await networkInfo.isConnected) {
      return Left(NoConnectionFailure());
    }
    return const Right(true);
  }
}
