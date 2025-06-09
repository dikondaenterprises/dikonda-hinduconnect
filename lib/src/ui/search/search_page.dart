import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../providers/user_provider.dart';
import '../../model/content_type.dart';
import 'result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _query = '';
  List<Map<String, String>> _allStotras = [];
  List<Map<String, String>> _allTemples = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
  if (!mounted) return;
final lang = context.read<UserProvider>().preferredLanguage;

const state = 'default'; // fixed since content is same for all
const templeKey = 'temples_default';

final stotraKey = 'stotras_$lang';
final cachedStotras = prefs.getString(stotraKey);
final cachedTemples = prefs.getString(templeKey);

    if (cachedStotras != null && cachedTemples != null) {
      setState(() {
        _allStotras = List<Map<String, String>>.from(json.decode(cachedStotras));
        _allTemples = List<Map<String, String>>.from(json.decode(cachedTemples));
      });
    } else {
      await _fetchAndCacheStotras(lang, prefs, stotraKey);
      await _fetchAndCacheTemples(state, prefs, templeKey);
    }
  }

  Future<void> _fetchAndCacheStotras(String lang, SharedPreferences prefs, String key) async {
    final url = Uri.parse('https://hindu-connect-app.web.app/assets/stotras/$lang/index.json');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> entries = json.decode(res.body);
        final List<Map<String, String>> data = [];
        for (var entry in entries) {
          final fileUrl = Uri.parse('https://hindu-connect-app.web.app/assets/stotras/$lang/$entry');
          final fileRes = await http.get(fileUrl);
          if (fileRes.statusCode == 200) {
            data.add({
              'title': entry.replaceAll('.txt', ''),
              'content': fileRes.body,
              'lang': lang,
            });
          }
        }
        setState(() => _allStotras = data);
        await prefs.setString(key, json.encode(data));
      }
    } catch (e) {
      debugPrint("Failed to fetch stotras: $e");
    }
  }

  Future<void> _fetchAndCacheTemples(String state, SharedPreferences prefs, String key) async {
    final url = Uri.parse('https://hindu-connect-app.web.app/assets/temples/$state/index.json');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> entries = json.decode(res.body);
        final List<Map<String, String>> data = [];
        for (var entry in entries) {
          final fileUrl = Uri.parse('https://hindu-connect-app.web.app/assets/temples/$state/$entry');
          final fileRes = await http.get(fileUrl);
          if (fileRes.statusCode == 200) {
            data.add({
              'title': entry.replaceAll('.md', ''),
              'content': fileRes.body,
            });
          }
        }
        setState(() => _allTemples = data);
        await prefs.setString(key, json.encode(data));
      }
    } catch (e) {
      debugPrint("Failed to fetch temples: $e");
    }
  }

  List<Map<String, String>> get filteredStotras {
    final lang = context.read<UserProvider>().preferredLanguage;
    return _allStotras
        .where((m) =>
            m['lang'] == lang &&
            (m['title']!.toLowerCase().contains(_query) ||
             m['content']!.toLowerCase().contains(_query)))
        .toList();
  }

  List<Map<String, String>> get filteredTemples {
    return _allTemples
        .where((m) =>
            m['title']!.toLowerCase().contains(_query) ||
            m['content']!.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Stotras'),
            Tab(text: 'Temples'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResults(filteredStotras, ContentType.stotra),
          _buildResults(filteredTemples, ContentType.temple),
        ],
      ),
    );
  }

  Widget _buildResults(List<Map<String, String>> results, ContentType type) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Search'),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                title: Text(item['title'] ?? ''),
                onTap: () {
                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ResultPage(
      id: item['id'] ?? '', // or use item['title'] as id if no 'id' key
      title: item['title'] ?? '',
      content: item['content'] ?? '',
      type: type,
    ),
  ),
);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
