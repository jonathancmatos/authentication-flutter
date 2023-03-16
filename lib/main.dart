import 'package:authentication_flutter/app/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

GlobalKey<NavigatorState> globalKeyNavigator = GlobalKey();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(
    module: AppModule(),
    child: Container(),
  ));
}
