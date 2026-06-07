import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<void> saveToken(String token) {
    return _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> readToken() {
    return _secureStorage.read(key: 'auth_token');
  }

  Future<void> saveLastBranch(String branchName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_branch', branchName);
  }
}
