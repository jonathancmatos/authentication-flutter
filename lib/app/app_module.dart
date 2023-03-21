import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/signup_screen.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/states/signup_store.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'features/auth/data/datasources/auth_datasource.dart';

class AppModule extends Module {

  @override
  List<Bind<Object>> get binds => [
    Bind.factory((i) => Dio()),
    Bind.factory((i) => DioHttpService(i())),
    Bind.factory((i) => InternetConnectionChecker()),
    Bind.factory((i) => NetworkInfoImpl(i())),
    Bind.factory((i) => AuthDataSourceImpl(i())),
    Bind.factory((i) => AuthRepositoryImpl(
      networkInfo: i(), 
      dataSource: i()
    )),
    Bind.factory((i) => NewAccountImpl(i())),
    Bind.factory((i) => SignUpStore(i()))
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => SignUpScreen())
  ];
}
