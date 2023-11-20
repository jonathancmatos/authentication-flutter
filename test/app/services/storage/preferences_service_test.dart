import 'package:authentication_flutter/app/services/storage/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main() {
  late PreferencesService preferencesService;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    preferencesService = PreferencesService(mockSharedPreferences);
  });

  test('should return true when save string data', () async {
    //arrange
    when(() => mockSharedPreferences.setString('key', 'test'))
        .thenAnswer((_) async => true);
    //act
    final result = await preferencesService.save(key: 'key', value: 'test');
    //assert
    expect(result, true);
  });

  test('should return string value saved', () {
    //arrange
    when(() => mockSharedPreferences.getString('key')).thenAnswer((_) => 'test');
    //act
    final result = preferencesService.read(key: 'key');
    //assert
    expect(result, equals('test'));
  });

  test('should removed key and values', () async {
    //arrange
    when(() => mockSharedPreferences.remove('key')).thenAnswer((_) async => true);
    //act
    final result = await preferencesService.remove(key: 'key');
    //assert
    expect(result, true);
  });
}
