import 'package:authentication_flutter/app/core/error/exception.dart';
import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/data/models/account_model.dart';
import 'package:authentication_flutter/app/features/auth/data/models/sign_in_model.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/new_account_entity.dart';
import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/sign_in_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  AuthDataSource dataSource;
  AuthRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, bool>>? signUp(NewAccountEntity account) async {
    final isConnected = await _checkNetworkConnected();
    return await isConnected.fold(
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
        } on ServerException catch (e) {
          return Left(ServerFailure(type: e.type, message: e.message));
        } on NoConnectionException {
          return Left(NoConnectionFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>>? signIn(SignInEntity signIn) async {
    final isConnected = await _checkNetworkConnected();
    return await isConnected.fold(
      (failure) => Left(NoConnectionFailure()),
      (success) async {
        try {
          final model = SignInModel(email: signIn.email, passwd: signIn.passwd);
          final response = await dataSource.signIn(model);

          //Save data to SharedPreferences
          final storage = Modular.get<SessionManager>();
          await storage.setAccessToken(response?["access_token"]);
          await storage.setRefreshToken(response?["refresh_token"]);

          return const Right(true);
        } on InternalException {
          return Left(InternalFailure());
        } on ServerException catch (e) {
          return Left(ServerFailure(type: e.type, message: e.message));
        } on NoConnectionException {
          return Left(NoConnectionFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, UserEntity>>? currentUser() async {
    final isConnected = await _checkNetworkConnected();
    return await isConnected.fold((failure) => Left(NoConnectionFailure()),
        (success) async {
      try {
        final response = await dataSource.currentUser();

        //Save data profile to SharedPrefernces
        final storage = Modular.get<PreferencesService>();
        await storage.save(
            key: keyProfile, value: response?.toJson().toString() ?? "");

        return Right(UserEntity(
          name: response?.name ?? "",
          email: response?.email ?? "",
          phone: response?.phone ?? "",
        ));
      } on InternalException {
        return Left(InternalFailure());
      } on ServerException catch (e) {
        return Left(ServerFailure(type: e.type, message: e.message));
      } on NoConnectionException {
        return Left(NoConnectionFailure());
      }
    });
  }

  @override
  Future<Either<Failure, bool>>? logout() async {
    final isConnected = await _checkNetworkConnected();
    return await isConnected.fold((failure) => Left(NoConnectionFailure()),
        (success) async {
      try {
        final response = await dataSource.logout();
        await _clearSessionsAndStorages();

        return Right(response ?? false);
      } on InternalException {
        await _clearSessionsAndStorages();  
        return Left(InternalFailure());
      } on ServerException catch (e) {
        await _clearSessionsAndStorages();  
        return Left(ServerFailure(type: e.type, message: e.message));
      } on NoConnectionException {
        return Left(NoConnectionFailure());
      }
    });
  }

  Future<void> _clearSessionsAndStorages() async {
    //Clear profile data
    final storage = Modular.get<PreferencesService>();
    await storage.remove(key: keyProfile);
    //Clear Sessions
    final session = Modular.get<SessionManager>();
    await session.clear();
  }

  Future<Either<Failure, bool>> _checkNetworkConnected() async {
    if (!await networkInfo.isConnected) {
      return Left(NoConnectionFailure());
    }
    return const Right(true);
  }
}
