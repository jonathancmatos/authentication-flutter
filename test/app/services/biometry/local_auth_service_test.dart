import 'package:authentication_flutter/app/services/biometry/local_auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalAuthService extends Mock implements LocalAuthentication {}

void main() {
  
  late MockLocalAuthService mockLocalAuthService;
  late LocalAuthService localAuthService;

  setUpAll((){
    mockLocalAuthService = MockLocalAuthService();
    localAuthService = LocalAuthService(mockLocalAuthService);
  });

  test("should return true check biometrics activated", () async{
    //arrange
    when(() => mockLocalAuthService.getAvailableBiometrics()).thenAnswer((_) async =>[BiometricType.fingerprint]);
    //act
    final result = await localAuthService.checkBiometricsActivated();
    //assert
    expect(result, equals(true));
  });

  test("should return false check biometrics activated", () async{
    //arrange
    when(() => mockLocalAuthService.getAvailableBiometrics()).thenAnswer((_) async =>[]);
    //act
    final result = await localAuthService.checkBiometricsActivated();
    //assert
    expect(result, equals(false));
  });

  test('should return true check device supports biometry', () async{
    //arrange
    when(() => mockLocalAuthService.canCheckBiometrics).thenAnswer((_) async => true);
    when(() => mockLocalAuthService.isDeviceSupported()).thenAnswer((_) async => true);
    //act
    final result = await localAuthService.isSupportBiometry();
    //assert
    expect(result, equals(true));
  });

  test('should return false check device supports biometry', () async{
    //arrange
    when(() => mockLocalAuthService.canCheckBiometrics).thenAnswer((_) async => false);
    when(() => mockLocalAuthService.isDeviceSupported()).thenAnswer((_) async => false);
    //act
    final result = await localAuthService.isSupportBiometry();
    //assert
    expect(result, equals(false));
  });

  test('shold return true when validate biometrics', () async{
    //arrange
    when(() => mockLocalAuthService.authenticate(
      localizedReason: 'Autentique-se para continuar.',
      options: const AuthenticationOptions(useErrorDialogs: false)
    )).thenAnswer((_) async => true);
    //act
    final result = await localAuthService.validateBiometrics();
    //assert
    expect(result, equals(true));
  });

  test('should return Exception error when return notAvailable', () async{
    //arrange
    when(() => mockLocalAuthService.authenticate(
      localizedReason: 'Autentique-se para continuar.',
      options: const AuthenticationOptions(useErrorDialogs: false)
    )).thenThrow(PlatformException(code: 'NotAvailable'));
    //act && assert
    expect(() => localAuthService.validateBiometrics(), throwsA(isA<Exception>()));
  });

  test('should return Exception error when return notEnrolled', () async{
    //arrange
    when(() => mockLocalAuthService.authenticate(
      localizedReason: 'Autentique-se para continuar.',
      options: const AuthenticationOptions(useErrorDialogs: false)
    )).thenThrow(PlatformException(code: 'NotEnrolled'));
    //act && assert
    expect(() => localAuthService.validateBiometrics(), throwsA(isA<Exception>()));
  });

  test('should return Exception error when return other error', () async{
    //arrange
    when(() => mockLocalAuthService.authenticate(
      localizedReason: 'Autentique-se para continuar.',
      options: const AuthenticationOptions(useErrorDialogs: false)
    )).thenThrow(PlatformException(code: 'error'));
    //act && assert
    expect(() => localAuthService.validateBiometrics(), throwsA(isA<Exception>()));
  });
}