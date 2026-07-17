import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;
  final Map<String, bool> _memoryBools = {};

  Future<SharedPreferences?> get _storage async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (_) {
      return null;
    }
  }

  Future<bool> getBool(String key) async {
    try {
      final prefs = await _storage;
      if (prefs != null) {
        return prefs.getBool(key) ?? _memoryBools[key] ?? false;
      }
    } catch (_) {
      // Plugin unavailable (e.g. after hot restart before full rebuild).
    }
    return _memoryBools[key] ?? false;
  }

  Future<void> setBool(String key, bool value) async {
    _memoryBools[key] = value;
    try {
      final prefs = await _storage;
      await prefs?.setBool(key, value);
    } catch (_) {
      // Keep in-memory value when native storage is unavailable.
    }
  }

  Future<void> saveString(String key, String value) async {
    try {
      final prefs = await _storage;
      await prefs?.setString(key, value);
    } catch (_) {}
  }

  Future<String?> getString(String key) async {
    try {
      final prefs = await _storage;
      return prefs?.getString(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> remove(String key) async {
    _memoryBools.remove(key);
    try {
      final prefs = await _storage;
      await prefs?.remove(key);
    } catch (_) {}
  }

  Future<void> clear() async {
    _memoryBools.clear();
    try {
      final prefs = await _storage;
      await prefs?.clear();
    } catch (_) {}
  }
}
