import 'package:authentication_flutter/app/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String keyProfile = "user_profile";

class PreferencesService implements StorageService {
  final SharedPreferences _preferences;
  PreferencesService(this._preferences);

  @override
  Future<bool> containsKey({required String key}) async {
    return _preferences.containsKey(key);
  }

  @override
  String? read({required String key}) {
    return _preferences.getString(key);
  }

  @override
  Future<bool> remove({required String key}) async {
    return await _preferences.remove(key);
  }

  @override
  Future<bool> save({required String key, required String value}) async {
    return await _preferences.setString(key, value);
  }
}
