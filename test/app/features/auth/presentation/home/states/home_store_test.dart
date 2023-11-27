import 'dart:convert';

import 'package:authentication_flutter/app/core/manager/user_manager_store.dart';
import 'package:authentication_flutter/app/features/auth/domain/entities/user_entity.dart';
import 'package:authentication_flutter/app/features/auth/presentation/home/states/home_store.dart';
import 'package:authentication_flutter/app/services/biometry/local_auth_service.dart';
import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../bootstrap/modular_test.dart';

class MockBiometryService extends Mock implements LocalAuthService {}
class MockStorageService extends Mock implements PreferencesService {}
class MockUserManagerStore extends Mock implements UserManagerStore {}

void main() {

  late HomeStore homeStore;
  late MockBiometryService mockBiometryService;
  late MockStorageService mockStorageService;
  late MockUserManagerStore mockUserManagerStore;

  setUpAll(() {
    mockBiometryService = MockBiometryService();
    mockStorageService = MockStorageService();
    mockUserManagerStore = MockUserManagerStore();
    Modular.init(TestModule());

    when(() => mockUserManagerStore.user).thenReturn(const UserEntity(
      email: 'test@example.com', 
      name: 'Test', 
      phone: ''));

    when(() => mockBiometryService.isSupportBiometry()).thenAnswer((_) async => true); 
    when(() => mockBiometryService.checkBiometricsActivated()).thenAnswer((_) async => true); 

    homeStore = HomeStore(
      biometryService: mockBiometryService,
      storageService: mockStorageService,
    );
    homeStore.user = mockUserManagerStore.user;
  });

  test('checked initial value', (){
    expect(homeStore.showOptionBiometric, true);
  });

  test('should change biometry value', () async {
    //arrange
    when(() => mockStorageService.read(key: any(named: 'key'))).thenAnswer((_) => null);
    when(() => mockStorageService.save(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async => true);
    //act
    homeStore.changeBiometryValue(true);
    //assert
    expect(homeStore.isBiometryRegisted, true);
  });

  test('change remove biometry value', () async {
    //arrange
    final strResult = json.encode([homeStore.user?.email]);
    when(() => mockStorageService.read(key: any(named: 'key'))).thenAnswer((_) => strResult);
    when(() => mockStorageService.save(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async => true);
    //act
    homeStore.changeBiometryValue(false);
    //assert
    expect(homeStore.isBiometryRegisted, false);
  });

  test('must return true when validating biometrics', () async {
    //arrange
    final strResult = json.encode([homeStore.user?.email]);
    when(() => mockStorageService.read(key: any(named: 'key'))).thenAnswer((_) => strResult);
    when(() => mockBiometryService.validateBiometrics()).thenAnswer((_) async => true);
    //act
    final result = await homeStore.checkRegisteredBiometrics();
    //assert
    expect(result, true);
  });

  test('must return false when validating biometrics', () async {
    //arrange
    final strResult = json.encode([homeStore.user?.email]);
    when(() => mockStorageService.read(key: any(named: 'key'))).thenAnswer((_) => strResult);
    when(() => mockBiometryService.validateBiometrics()).thenAnswer((_) async => false);
    //act
    final result = await homeStore.checkRegisteredBiometrics();
    //assert
    expect(result, false);
  });

}