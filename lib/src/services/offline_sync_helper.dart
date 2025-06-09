import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

/// Batch-downloads and caches Stotra and Temple files for offline use.
class OfflineSyncHelper {
  static const _cacheBox = 'fileCache';

  /// [baseUrl]: your Firebase Hosting base URL (no trailing slash)
  /// [stotraPaths]: list of paths like 'telugu/sri_vishnu.txt'
  /// [templePaths]: list of paths like 'telangana/tirupati.md'
  static Future<void> syncFiles({
    required String baseUrl,
    required List<String> stotraPaths,
    required List<String> templePaths,
  }) async {
    final box = await Hive.openBox(_cacheBox);

    // Helper to fetch & store
    Future<void> fetchAndStore(String path, String type) async {
      final url = '$baseUrl/assets/${type == 'stotra' ? 'stotras' : 'temples'}/$path';
      try {
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode == 200) {
          final content = utf8.decode(resp.bodyBytes);
          final title = path.split('/').last.replaceAll(RegExp(r'\.txt|\.md'), '').replaceAll('_', ' ');
          await box.put('${type}_$path', {
            'id': '${type}_$path',
            'title': title,
            'content': content,
            'type': type,
          });
        }
      } catch (_) {
        // ignore individual failures
      }
    }

    // Download stotras
    for (final path in stotraPaths) {
      await fetchAndStore(path, 'stotra');
    }
    // Download temples
    for (final path in templePaths) {
      await fetchAndStore(path, 'temple');
    }
  }
}
