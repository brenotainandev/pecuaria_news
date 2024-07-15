import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecuaria_news/features/home/widgets/news_list_item.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  static const int pageSize = 2;
  List<dynamic> loadedNewsItems = [];
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    final jsonString = await rootBundle.loadString('assets/json/news.json');
    final jsonResponse = json.decode(jsonString);
    loadedNewsItems.addAll(jsonResponse['newsItems'].sublist(0, pageSize));
    _isLoading = false;
    setState(() {});
  }

  Future<void> _loadMoreData() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    final jsonString = await rootBundle.loadString('assets/json/news.json');
    final jsonResponse = json.decode(jsonString);
    final totalItems = jsonResponse['newsItems'].length;
    final int nextIndex = loadedNewsItems.length + pageSize;
    // Garante que o índice final não exceda o tamanho total da lista
    final int endIndex = nextIndex > totalItems ? totalItems : nextIndex;

    List<dynamic> nextItems =
        jsonResponse['newsItems'].sublist(loadedNewsItems.length, endIndex);

    if (nextItems.isEmpty) {
      _hasMore = false;
    } else {
      // Carrega e exibe cada item individualmente com um atraso
      for (var item in nextItems) {
        loadedNewsItems.add(item);
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {});
      }
    }

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == loadedNewsItems.length) {
            if (_hasMore) {
              _loadMoreData();
              return const Center(child: CircularProgressIndicator());
            }
            return null;
          }
          final newsItem = loadedNewsItems[index];
          return NewsListItem(
            idNews: newsItem['idNews']!,
            imageAssetPath: newsItem['imageAssetPath']!,
            category: newsItem['category']!,
            title: newsItem['title']!,
            content: newsItem['content']!,
            author: newsItem['author']!,
            authorImageAssetPath: newsItem['authorImageAssetPath']!,
            date: DateTime.parse(newsItem['date']!),
          );
        },
        childCount: loadedNewsItems.length + (_hasMore ? 1 : 0),
      ),
    );
  }
}
