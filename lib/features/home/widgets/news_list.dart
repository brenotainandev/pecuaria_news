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
  List<dynamic> newsItems = [];

  @override
  void initState() {
    super.initState();
    _loadNewsItems();
  }

  Future<void> _loadNewsItems() async {
    final jsonString = await rootBundle.loadString('assets/json/news.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      newsItems = jsonResponse['newsItems'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => NewsListItem(
          idNews: newsItems[i]['idNews']!,
          imageAssetPath: newsItems[i]['imageAssetPath']!,
          category: newsItems[i]['category']!,
          title: newsItems[i]['title']!,
          content: newsItems[i]['content']!,
          author: newsItems[i]['author']!,
          authorImageAssetPath: newsItems[i]['authorImageAssetPath']!,
          date: DateTime.parse(newsItems[i]['date']!),
        ),
        childCount: newsItems.length,
      ),
    );
  }
}
