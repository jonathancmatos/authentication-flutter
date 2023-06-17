import 'package:authentication_flutter/app/services/storage/storage_service.dart';

const String _keyAccessToken = "access_token";
const String _keyRefreshToken = "refresh_token";

class SessionManager {
  
  final StorageService _storageService;
  SessionManager(this._storageService);

  Future<void> setAccessToken(String value) async {
    await _storageService.save(key: _keyAccessToken, value: value);
  }

  String? getAccessToken() {
    return _storageService.read(key: _keyAccessToken);
  }


  Future<void> setRefreshToken(String value) async {
    await _storageService.save(key: _keyRefreshToken, value: value);
  }

  String? getRefreshToken() {
    return _storageService.read(key: _keyRefreshToken);
  }


  Future<void> clear() async {
    await _storageService.remove(key: _keyAccessToken);
    await _storageService.remove(key: _keyRefreshToken);
  }
}
