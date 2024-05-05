import 'package:flutter/material.dart';
import 'package:pecuaria_news/features/home/widgets/single_news_item_header_delagate.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class SingeNewsItemPage extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final String category;
  final String authorImageAssetPath;
  final String imageAssetPath;
  final DateTime date;

  const SingeNewsItemPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.authorImageAssetPath,
    required this.imageAssetPath,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final topPading = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SingleNewsItemHeaderDelegate(
              title: title,
              category: category,
              imageAssetPath: imageAssetPath,
              date: date,
              minExtent: topPading + 56,
              maxExtent: maxScreenSizeHeight / 2,
              topPadding: topPading,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
