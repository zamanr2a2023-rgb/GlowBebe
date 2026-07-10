class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  Future<void> saveString(String key, String value) async {
    // TODO: Implement with shared_preferences or secure_storage
  }

  Future<String?> getString(String key) async {
    // TODO: Implement with shared_preferences or secure_storage
    return null;
  }

  Future<void> remove(String key) async {
    // TODO: Implement with shared_preferences or secure_storage
  }

  Future<void> clear() async {
    // TODO: Implement with shared_preferences or secure_storage
  }
}
