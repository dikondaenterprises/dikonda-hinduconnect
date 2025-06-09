import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../model/content_type.dart';
import '../search/result_page.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late Box<bool> _bookmarkBox;
  late Box _fileCacheBox;

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    _bookmarkBox = await Hive.openBox<bool>('bookmarks');
    _fileCacheBox = await Hive.openBox('fileCache');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('bookmarks') || !Hive.isBoxOpen('fileCache')) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bookmarkedKeys = _bookmarkBox.keys.where((k) => _bookmarkBox.get(k) == true);

    if (bookmarkedKeys.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Bookmarks')),
        body: Center(child: Text('No bookmarks yet.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: ListView(
        children: bookmarkedKeys.map((key) {
          final data = _fileCacheBox.get(key);
          if (data == null) return const SizedBox.shrink();

          final id = key as String;
          final title = data['title'] as String? ?? 'Untitled';
          final content = data['content'] as String;
          final typeStr = data['type'] as String? ?? 'stotra';
          final type = typeStr == 'stotra' ? ContentType.stotra : ContentType.temple;

          return ListTile(
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultPage(
                    id: id,
                    title: title,
                    content: content,
                    type: type,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
