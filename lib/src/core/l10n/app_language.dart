import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { en, mr, hi }

class AppLanguageNotifier extends ChangeNotifier {
  AppLanguage _language = AppLanguage.en;

  AppLanguage get language => _language;

  AppLanguageNotifier() {
    _loadSaved();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang.name);
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('app_language');
    if (saved == null) return;
    final lang = AppLanguage.values.where((e) => e.name == saved).firstOrNull;
    if (lang != null && lang != _language) {
      _language = lang;
      notifyListeners();
    }
  }
}
