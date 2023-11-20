import 'package:authentication_flutter/app/core/error/failure.dart';
import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/get_current_user.dart';
import 'package:authentication_flutter/app/features/auth/domain/usercases/logout.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import '../../bootstrap/modular_test.dart';

class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockLogout extends Mock implements Logout {}

void main() {

  late UserManagerStore userManagerStore;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockLogout mockLogout;
  
  late PreferencesService preferencesService;
  late SessionManager sessionManager;

  setUpAll((){
    mockGetCurrentUser = MockGetCurrentUser();
    mockLogout = MockLogout();
    userManagerStore = UserManagerStore(mockGetCurrentUser, mockLogout);

    Modular.init(TestModule());
    preferencesService = Modular.get<PreferencesService>(); 
    sessionManager = Modular.get<SessionManager>();  
  });

  test('Initial state should be not loading and user should be null', () {
    expect(userManagerStore.isLoading, false);
    expect(userManagerStore.user, isNull);
  });

  group('GetCurrentUser', () {
    test('must return UserEntity when returning logged in user data', () async {
      // arrange
      when(() => mockGetCurrentUser.call()).thenAnswer((_) async => const Right(UserEntity(
        name: 'John',
        email: 'johndoe@contact.com.br',
        phone: ''
      )));

      // act
      await userManagerStore.getCurrentUser();

      // assert
      expect(userManagerStore.isLoading, false);
      expect(userManagerStore.user?.name, 'John');
    });

    test('must return ServerFailure when returning logged in user data', () async {
      // arrange
      when(() => preferencesService.remove(key: 'user_profile')).thenAnswer((_) async => true);
      when(() => sessionManager.clear()).thenAnswer((_) async => true);
      when(() => mockGetCurrentUser.call()).thenAnswer((_) async => const Left(ServerFailure(
        type: 'Error',
        message: 'Houve um erro'
      )));

      // act
      await userManagerStore.getCurrentUser();

      // assert
      expect(userManagerStore.isLoading, false);
    });
  });

  group('Logoff', () {
    test('must return user null when logout is successful', () async {
      // arrange
      when(() => preferencesService.remove(key: 'user_profile')).thenAnswer((_) async => true);
      when(() => sessionManager.clear()).thenAnswer((_) async => true);
      when(() => mockLogout.call()).thenAnswer((_) async => const Right(null));

      // act
      await userManagerStore.logoff();

      // assert
      verify(() => mockLogout.call());
    });

    test('should return ServerFailure when there is a logout failure', () async {
      // Arrange
      when(() => mockLogout.call()).thenAnswer((_) async => const Left(ServerFailure(
        type: 'Error',
        message: 'Houve um erro'
      )));

      // Act
      await userManagerStore.logoff();

      // Assert
      verify(() => mockLogout.call());
    });
  });

}