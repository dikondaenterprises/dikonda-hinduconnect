import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app/providers/user_provider.dart';
import 'package:your_app/model/content_type.dart';
import 'result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _query = '';
  final List<Map<String, String>> _allStotras = []; // load via FileService or manifest
  final List<Map<String, String>> _allTemples = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: load _allStotras and _allTemples from cache or manifest
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
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Stotras'),
          Tab(text: 'Temples'),
        ]),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _query = v.toLowerCase()),
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            _buildList(filteredStotras, ContentType.stotra),
            _buildList(filteredTemples, ContentType.temple),
          ]),
        ),
      ]),
    );
  }

  Widget _buildList(List<Map<String, String>> list, ContentType type) {
    if (list.isEmpty) return const Center(child: Text('No results'));
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        return ListTile(
          title: Text(item['title']!),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultPage(
                id: item['id']!,
                title: item['title']!,
                content: item['content']!,
                type: type,
              ),
            ),
          ),
        );
      },
    );
  }
}
