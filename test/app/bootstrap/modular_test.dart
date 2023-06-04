import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mockito/annotations.dart';
import 'modular_test.mocks.dart';


@GenerateMocks([SessionManager])

class TestModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<SessionManager>((i) => MockSessionManager()),
    // Adicione outros binds necessários para os testes
  ];
}

void main() {}