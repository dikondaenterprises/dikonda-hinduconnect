import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FileService {
  /// Loads content from network or cache.
  /// - [url]: full HTTPS URL to the .txt or .md file.
  static Future<String> loadFileContent(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'file_$url';

    // Try network first
    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final body = resp.body;
        await prefs.setString(cacheKey, body);
        return body;
      }
    } catch (_) {
      // network error, fall back to cache
    }

    // Fallback to cache
    final cached = prefs.getString(cacheKey);
    if (cached != null) return cached;

    throw Exception('Failed to load file content');
  }
}
