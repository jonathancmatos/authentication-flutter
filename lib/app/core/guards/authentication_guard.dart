import 'dart:async';
import 'package:authentication_flutter/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthenticateGuard extends RouteGuard {
  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    await Modular.isModuleReady<AppModule>();
    return true;
  }
}
