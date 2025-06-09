import 'dart:convert';
import 'package:http/http.dart' as http;

class ManifestService {
  static const String _baseUrl = 'https://your-firebase-hosting-domain.web.app/assets';

  /// Fetches the list of `.txt` filenames under `/assets/stotras/{lang}/manifest.json`
  static Future<List<String>> fetchStotraManifest(String lang) async {
    final uri = Uri.parse('$_baseUrl/stotras/$lang/manifest.json');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load stotra manifest for $lang');
    }
  }

  /// Fetches the list of `.md` filenames under `/assets/temples/{state}/manifest.json`
  static Future<List<String>> fetchTempleManifest(String state) async {
    final uri = Uri.parse('$_baseUrl/temples/$state/manifest.json');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load temple manifest for $state');
    }
  }
}
