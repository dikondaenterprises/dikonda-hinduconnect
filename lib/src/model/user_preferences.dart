import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _langKey = 'preferred_stotra_language';

  static Future<void> setPreferredLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang);
  }

  static Future<String> getPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? 'english';
  }
}
