import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/regenerate_access_token.dart';
import 'package:authentication_flutter/app/services/http/unauthorized_request_retrier.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mocktail/mocktail.dart';

class MockPreferencesService extends Mock implements PreferencesService {}
class MockSessionManager extends Mock implements SessionManager {}
class MockUserManagerStore extends Mock implements UserManagerStore {}
class MockRegenerateAccessTokenImpl extends Mock implements RegenerateAccessTokenImpl{}
class MocknauthorizedRequestRetrierImpl extends Mock implements UnauthorizedRequestRetrierImpl{}


class TestModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<PreferencesService>((i) => MockPreferencesService()), 
    Bind<SessionManager>((i) => MockSessionManager()), 
    Bind<UserManagerStore>((i) => MockUserManagerStore()), 
    Bind<RegenerateAccessTokenImpl>((i) => MockRegenerateAccessTokenImpl()),
    Bind<UnauthorizedRequestRetrierImpl>((i) => MocknauthorizedRequestRetrierImpl())  
  ];
}

void main() {}