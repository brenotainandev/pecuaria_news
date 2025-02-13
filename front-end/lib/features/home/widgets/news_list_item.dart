import 'package:flutter/material.dart';
import 'package:pecuaria_news/core/utils/app_date_formattedrs.dart';
import 'package:pecuaria_news/features/home/pages/singe_news_item_page.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class NewsListItem extends StatelessWidget {
  final int idNews;
  final String title;
  final String content;
  final String author;
  final String category;
  final String authorImageAssetPath;
  final String imageAssetPath;
  final DateTime date;

  const NewsListItem({
    super.key,
    required this.idNews,
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageAssetPath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.osloGrey,
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          authorImageAssetPath,
                        ),
                        radius: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '$author · ${AppDateFormatters.mdY(date)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.osloGrey,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
