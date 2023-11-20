import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements StorageService{}

void main() {
  late SessionManager sessionManager;
  late MockStorageService mockStorageService;
  const String token = "test_token";

  setUp(() {
    mockStorageService = MockStorageService();
    sessionManager = SessionManager(mockStorageService);
  });
  

  test('must clear access_token and refresh_token', () async{
     when(() => mockStorageService.remove(key: 'access_token'))
        .thenAnswer((_) async => true);
      when(() => mockStorageService.remove(key: 'refresh_token'))
        .thenAnswer((_) async => true);
      //act
      await sessionManager.clear();
      //assert
      verify(() => mockStorageService.remove(key: 'access_token'));
      verify(() => mockStorageService.remove(key: 'refresh_token'));
  });

  group("AccessToken", () {
    test('set access token should save token', () async {
      when(() => mockStorageService.save(key: 'access_token', value: token))
          .thenAnswer((_) async => true);
      //act
      await sessionManager.setAccessToken(token);
      //assert
      verify(() => mockStorageService.save(key: 'access_token', value: token));
    });

    test('get access token should return saved token', () async {
      //arrange
      when(() => mockStorageService.read(key: 'access_token'))
          .thenAnswer((_) => token);
      //act
      final result = sessionManager.getAccessToken();
      //assert
      expect(result, equals(result));
    });
  });

  group("RefreshToken", () {
    test('set refresh token should save token', () async {
      when(() => mockStorageService.save(key: 'refresh_token', value: token))
          .thenAnswer((_) async => true);
      //act
      await sessionManager.setRefreshToken(token);
      //assert
      verify(() => mockStorageService.save(key: 'refresh_token', value: token));
    });

    test('get refresh token should return saved token', () async {
      //arrange
      when(() => mockStorageService.read(key: 'refresh_token'))
          .thenAnswer((_) => token);
      //act
      final result = sessionManager.getRefreshToken();
      //assert
      expect(result, equals(result));
    });
  });
}
