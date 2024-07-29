import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecuaria_news/api/servicos.dart';
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
  late ServicoNews _servicoNNews;

  @override
  void initState() {
    super.initState();
    _servicoNNews = ServicoNews();
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
        await _servicoNNews.getProdutos(startIndex, pageSize);

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
            idNews: newsItem['idNews'] ?? 'ID Desconhecido',
            imageAssetPath: caminhoArquivo(newsItem['imageAssetPath']) ?? '',
            category: newsItem['category'] ?? 'Categoria Desconhecida',
            title: newsItem['title'] ?? 'Título Desconhecido',
            content: newsItem['content'] ?? 'Conteúdo não disponível',
            author: newsItem['author'] ?? 'Autor Desconhecido',
            authorImageAssetPath:
                caminhoArquivo(newsItem['authorImageAssetPath']) ?? '',
            date: newsItem['date'] != null
                ? DateTime.parse(newsItem['date']!)
                : DateTime.now(),
          );
        },
        childCount: loadedNewsItems.length + 1,
      ),
    );
  }
}
