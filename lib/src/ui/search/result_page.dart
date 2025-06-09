import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/content_type.dart';

class ResultPage extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final ContentType type;

  const ResultPage({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    super.key,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double _fontSize = 18.0;
  late Box<bool> _bookmarkBox;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    Hive.openBox<bool>('bookmarks').then((b) {
      _bookmarkBox = b;
      setState(() {
        _bookmarked = b.get(widget.id, defaultValue: false)!;
      });
    });
  }

  void _toggleBookmark() {
    setState(() {
      _bookmarked = !_bookmarked;
      _bookmarkBox.put(widget.id, _bookmarked);
    });
  }

  void _shareApp() {
    Share.share('Explore devotional content: https://yourappdownloadlink.com');
  }

  @override
  Widget build(BuildContext context) {
    final isStotra = widget.type == ContentType.stotra;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_bookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
          IconButton(icon: const Icon(Icons.share), onPressed: _shareApp),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            onPressed: () => setState(() => _fontSize = (_fontSize - 2).clamp(12, 40)),
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            onPressed: () => setState(() => _fontSize += 2),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isStotra
            ? SingleChildScrollView(child: Text(widget.content, style: TextStyle(fontSize: _fontSize)))
            : Markdown(data: widget.content, styleSheet: MarkdownStyleSheet(p: TextStyle(fontSize: _fontSize))),
      ),
    );
  }
}
