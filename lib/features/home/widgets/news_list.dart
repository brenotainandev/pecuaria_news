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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    final jsonResponse = await _fetchNewsData();
    loadedNewsItems.addAll(jsonResponse['newsItems'].sublist(0, pageSize));
    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> _loadMoreData() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    final jsonResponse = await _fetchNewsData();
    final totalItems = jsonResponse['newsItems'].length;
    final int startIndex = _currentPage * pageSize;
    final int endIndex =
        startIndex + pageSize > totalItems ? totalItems : startIndex + pageSize;
    List<dynamic> nextItems =
        jsonResponse['newsItems'].sublist(startIndex, endIndex);

    if (nextItems.isEmpty) {
      _hasMore = false;
    } else {
      loadedNewsItems.addAll(nextItems);
      _currentPage++;
    }

    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future<Map<String, dynamic>> _fetchNewsData() async {
    final jsonString = await rootBundle.loadString('assets/json/news.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= loadedNewsItems.length && _hasMore && !_isLoading) {
            _loadMoreData();
          }
          if (index == loadedNewsItems.length) {
            return _hasMore
                ? const Center(child: CircularProgressIndicator())
                : null;
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
        childCount: loadedNewsItems.length + 1,
      ),
    );
  }
}
