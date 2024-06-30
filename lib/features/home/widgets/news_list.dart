import 'package:flutter/material.dart';
import 'package:pecuaria_news/dummy.dart';
import 'package:pecuaria_news/features/home/widgets/news_list_item.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => NewsListItem(
          idNews: newsrItems[i]['idNews']!,
          imageAssetPath: newsrItems[i]['imageAssetPath']!,
          category: newsrItems[i]['category']!,
          title: newsrItems[i]['title']!,
          content: newsrItems[i]['content']!,
          author: newsrItems[i]['author']!,
          authorImageAssetPath: newsrItems[i]['authorImageAssetPath']!,
          date: DateTime.parse(newsrItems[i]['date']!),
        ),
        childCount: newsrItems.length,
      ),
    );
  }
}
