import 'package:flutter/material.dart';
import 'package:pecuaria_news/core/utils/app_date_formattedrs.dart';
import 'package:pecuaria_news/features/home/pages/singe_news_item_page.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class HomeSliderItem extends StatelessWidget {
  final bool isActived;
  final int idNews;
  final String imageAssetPath;
  final String category;
  final String title;
  final String content;
  final String author;
  final String authorImageAssetPath;
  final DateTime date;

  const HomeSliderItem({
    super.key,
    required this.idNews,
    required this.isActived,
    required this.imageAssetPath,
    required this.category,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.authorImageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingeNewsItemPage(
              idNews: idNews,
              title: title,
              content: content,
              author: author,
              category: category,
              authorImageAssetPath: authorImageAssetPath,
              imageAssetPath: imageAssetPath,
              date: date,
            ),
          ),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1.08,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: isActived ? 1 : 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image.network(
                  imageAssetPath,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Chip(
                    label: Text(
                      category,
                      style: const TextStyle(color: AppColors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.black08,
                        AppColors.black06,
                        AppColors.black00,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$author · ${AppDateFormatters.mdY(date)}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.white,
                                ),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
