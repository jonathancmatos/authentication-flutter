import 'package:authentication_flutter/app/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app/app_widget.dart';

GlobalKey<NavigatorState> globalKeyNavigator = GlobalKey();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
