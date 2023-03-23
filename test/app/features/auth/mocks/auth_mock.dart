import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/datasources/auth_datasource.dart';
import 'package:authentication_flutter/app/features/auth/domain/repositories/auth_repository.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<DioHttpService>(as: #MockDioHttpService)])
@GenerateMocks([
  NewAccount,
  AuthRepository,
  AuthDataSource,
  NetworkInfo,
  SessionManager,
])

void main() {}
