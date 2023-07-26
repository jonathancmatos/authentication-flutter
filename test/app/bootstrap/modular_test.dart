import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mockito/annotations.dart';
import 'modular_test.mocks.dart';

@GenerateMocks([
  SessionManager,
  PreferencesService,
  UserManagerStore,
  RegenerateAccessTokenImpl
])

class TestModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<PreferencesService>((i) => MockPreferencesService()), 
    Bind<SessionManager>((i) => MockSessionManager()), 
    Bind<UserManagerStore>((i) => MockUserManagerStore()), 
    Bind<RegenerateAccessTokenImpl>((i) => MockRegenerateAccessTokenImpl()) 
  ];
}

void main() {}