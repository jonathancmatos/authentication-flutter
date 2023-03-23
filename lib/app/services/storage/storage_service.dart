abstract class StorageService {
  Future<bool> save({required String key, required String value});
  String? read({required String key});
  Future<bool> containsKey({required String key});
  Future<bool> remove({required String key});
}
