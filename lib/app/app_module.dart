import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/core/network/network_info.dart';
import 'package:authentication_flutter/app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/get_current_user.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/logout.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/new_account.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/sign_in_with_email.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signin/signin_screen.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signin/states/signin_store.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/signup_screen.dart';
import 'package:authentication_flutter/app/features/auth/presentation/signup/states/signup_store.dart';
import 'package:authentication_flutter/app/features/auth/presentation/home/home_screen.dart';
import 'package:authentication_flutter/app/features/auth/presentation/welcome/welcome_screen.dart';
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
    // Global -> Session
    AsyncBind<SharedPreferences>((i) => SharedPreferences.getInstance()),
    Bind.factory((i) => PreferencesService(i())),
    Bind.factory((i) => SessionManager(i())),

    // Core -> DIO
    Bind.factory((i) => Dio()),
    Bind.factory((i) => DioHttpService(i())),

    // Core -> Checked Network Connection
    Bind.factory((i) => InternetConnectionChecker()),
    Bind.factory((i) => NetworkInfoImpl(i())),

    // Auth -> Datasource
    Bind.factory((i) => AuthDataSourceImpl(i())),
    // Auth -> Repository
    Bind.factory((i) => AuthRepositoryImpl(
      networkInfo: i(), 
      dataSource: i()
    )),
    // Auth -> Usercases
    Bind.factory((i) => GetCurrentUserImpl(i())),
    Bind.factory((i) => NewAccountImpl(i())),
    Bind.factory((i) => SignInWithEmailImpl(i())),
    Bind.factory((i) => LogoutImpl(i())),
    // Auth -> Store
    Bind.singleton((i) => UserManagerStore(i<GetCurrentUserImpl>(),i<LogoutImpl>())),
    Bind.factory((i) => SignUpStore(i())),
    Bind.factory((i) => SignInStore(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute("/", child: (context, args) => const WelcomeScreen(), guards: [AuthenticateGuard()]),
    ChildRoute("/login", child: (context, args) => SignInScreen()),
    ChildRoute("/register", child: (context, args) => const SignUpScreen()),
    ChildRoute("/me", child: (context, args) => const HomeScreen())
  ];
}
