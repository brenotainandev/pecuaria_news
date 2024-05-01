import 'package:flutter/material.dart';
import 'package:pecuaria_news/dummy.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider_item.dart';

class HomeSlide extends StatefulWidget {
  const HomeSlide({super.key});

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide> {
  late final PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1000);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index % newsrItems.length;
          });
        },
        controller: _pageController,
        itemBuilder: (context, index) {
          final i = index % newsrItems.length;
          return HomeSliderItem(
            isActived: _pageIndex == i,
            imageAssetPath: newsrItems[i]['imageAssetPath']!,
            category: newsrItems[i]['category']!,
            title: newsrItems[i]['title']!,
            author: newsrItems[i]['author']!,
            date: DateTime.parse(newsrItems[i]['date']!),
          );
        },
      ),
    );
  }
}
