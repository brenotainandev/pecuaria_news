import 'package:flutter/material.dart';
import 'package:pecuaria_news/features/home/widgets/single_news_item_header_delagate.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class SingeNewsItemPage extends StatefulWidget {
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
  State<SingeNewsItemPage> createState() => _SingeNewsItemPageState();
}

class _SingeNewsItemPageState extends State<SingeNewsItemPage> {
  double _borderRadiusMultiplier = 1;

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
              borderRadiusAnimation: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _borderRadiusMultiplier = value;
                  });
                });
              },
              title: widget.title,
              category: widget.category,
              imageAssetPath: widget.imageAssetPath,
              date: widget.date,
              minExtent: topPading + 56,
              maxExtent: maxScreenSizeHeight / 2,
              topPadding: topPading,
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: AnimatedContainer(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(40 * _borderRadiusMultiplier),
                color: AppColors.white,
              ),
              duration: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.author,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(widget.content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
