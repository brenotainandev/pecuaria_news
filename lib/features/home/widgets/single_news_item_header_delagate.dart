import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pecuaria_news/core/app_rounded_button_blur.dart';
import 'package:pecuaria_news/core/utils/app_date_formattedrs.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class SingleNewsItemHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String category;
  final String imageAssetPath;
  final DateTime date;
  final double topPadding;

  @override
  final double maxExtent;
  @override
  final double minExtent;

  const SingleNewsItemHeaderDelegate({
    required this.title,
    required this.category,
    required this.imageAssetPath,
    required this.date,
    required this.maxExtent,
    required this.minExtent,
    required this.topPadding,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final screenWhidth = MediaQuery.of(context).size.width;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageAssetPath,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          child: SizedBox(
            width: screenWhidth,
            child: Column(
              children: [
                SizedBox(
                  height: topPadding,
                ),
                Row(
                  children: [
                    AppRoundedButtonBlur(
                      iconData: CupertinoIcons.left_chevron,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        AppRoundedButtonBlur(
                          iconData: CupertinoIcons.bookmark,
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AppRoundedButtonBlur(
                          iconData: Icons.more_horiz,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: maxExtent / 2,
            width: screenWhidth,
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
          ),
        ),
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(
                    category,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppDateFormatters.mdY(date),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}
