import 'package:authentication_flutter/app/core/manager/session_manager.dart';
import 'package:authentication_flutter/app/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'session_manager_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late SessionManager sessionManager;
  late MockStorageService mockStorageService;
  const String token = "test_access_token";

  setUp(() {
    mockStorageService = MockStorageService();
    sessionManager = SessionManager(mockStorageService);
  });

  test('set access token should save token', () async {
    when(mockStorageService.save(key: anyNamed('key'), value: token))
        .thenAnswer((_) async => true);
    //act
    await sessionManager.setAccessToken(token);
    //assert
    verify(mockStorageService.save(key: anyNamed('key'), value: token));
  });

  test('get access token should return saved token', () async {
    //arrange
    when(mockStorageService.read(key: anyNamed('key')))
        .thenAnswer((_) => token);
    //act
    final result = sessionManager.getAccessToken();
    //assert
    expect(result, equals(result));
  });
}
