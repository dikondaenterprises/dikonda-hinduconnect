import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class OfflineHelper {
  /// Fetches [url], caches it under relative path [relativePath], returns content.
  /// On network error, falls back to cache.
  static Future<String> fetchAndCache(String url, String relativePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$relativePath');

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        await file.parent.create(recursive: true);
        await file.writeAsString(resp.body);
        return resp.body;
      }
      throw Exception('HTTP ${resp.statusCode}');
    } catch (_) {
      if (await file.exists()) {
        return await file.readAsString();
      }
      rethrow;
    }
  }
}
