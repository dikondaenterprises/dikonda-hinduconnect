import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:your_app/ui/search/result_page.dart';
import 'package:your_app/model/content_type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box _cacheBox;
  final List<String> _banners = [
    'https://cdn.example.com/banner1.jpg',
    'https://cdn.example.com/banner2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    Hive.openBox('fileCache').then((b) {
      _cacheBox = b;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final trending = _cacheBox.isOpen
        ? _cacheBox.keys
            .where((k) => k.toString().startsWith('stotra_'))
            .take(5)
            .map((k) => _cacheBox.get(k))
            .toList()
        : <dynamic>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _cacheBox.isOpen
          ? ListView(
              children: [
                CarouselSlider(
                  items: _banners
                      .map((url) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                          ))
                      .toList(),
                  options: CarouselOptions(autoPlay: true, height: 180),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Trending Stotras', style: TextStyle(fontSize: 20)),
                ),
                ...trending.map((data) {
                  final title = data['title'] as String;
                  final content = data['content'] as String;
                  final id = data['id'] as String;
                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultPage(
                            id: id,
                            title: title,
                            content: content,
                            type: ContentType.stotra,
                          ),
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Your Insights', style: TextStyle(fontSize: 20)),
                ),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: const Icon(Icons.insights),
                    title: Text('Bookmarks: ${Hive.box('bookmarks').values.where((v) => v==true).length}'),
                    subtitle: const Text('Continue your spiritual journey'),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
