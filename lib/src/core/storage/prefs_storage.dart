import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared preferences wrapper for non-sensitive data.
@lazySingleton
class PrefsStorage {
  PrefsStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }
}
