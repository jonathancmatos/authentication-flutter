import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/signup_screen.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/states/signup_store.dart';
import 'package:authentication_flutter/app/services/http/dio_http_service.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/guards/authentication_guard.dart';
import 'features/auth/data/datasources/auth_datasource.dart';

class AppModule extends Module {

  @override
  List<Bind<Object>> get binds => [
    //Global -> Session Manager
    AsyncBind<SharedPreferences>((i) => SharedPreferences.getInstance()),
    Bind.singleton((i) => PreferencesService(i())),
    Bind.singleton((i) => SessionManager(i())),
       
    //Auth Core -> DIO
    Bind.factory((i) => Dio()),
    Bind.factory((i) => DioHttpService(i())),
    //Auth Core -> NetWork
    Bind.factory((i) => InternetConnectionChecker()),
    Bind.factory((i) => NetworkInfoImpl(i())),
    //Auth DataSource
    Bind.factory((i) => AuthDataSourceImpl(i())),
    //Auth Repository
    Bind.factory((i) => AuthRepositoryImpl(
      networkInfo: i(), 
      dataSource: i()
    )),
    //Auth Usecase
    Bind.factory((i) => NewAccountImpl(i())),
    //Auth Store
    Bind.factory((i) => SignUpStore(i()))
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const SignUpScreen(), guards: [AuthenticateGuard()])
  ];
}
