import 'package:flutter/material.dart';
import 'package:pecuaria_news/core/utils/app_date_formattedrs.dart';
import 'package:pecuaria_news/features/home/pages/singe_news_item_page.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class NewsListItem extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final String category;
  final String authorImageAssetPath;
  final String imageAssetPath;
  final DateTime date;

  const NewsListItem({
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingeNewsItemPage(
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
              child: Image.asset(
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
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: AppColors.osloGrey,
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          authorImageAssetPath,
                        ),
                        radius: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '$author · ${AppDateFormatters.mdY(date)}',
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
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
