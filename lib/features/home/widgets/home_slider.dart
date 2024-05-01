import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pecuaria_news/dummy.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider_indicator_item.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider_item.dart';

class HomeSlide extends StatefulWidget {
  const HomeSlide({super.key});

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide> {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late final double _indicatorsVisibleWidth;

  int _pageIndex = 0;

  final _displayIdicatorsCount = 5.0;
  final _indicatorWidth = 10.0;
  final _activedIndicatorWidth = 32.0;
  final _indicatorMargin = const EdgeInsets.symmetric(horizontal: 1);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1000);
    _scrollController =
        ScrollController(initialScrollOffset: _calculateIndicatorOffset());

    _indicatorsVisibleWidth = _calculateIndicatorWidth();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  double _calculateIndicatorWidth() {
    final indicatorTotalWidth =
        _indicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    final activedIndicatorTotalWidth =
        _activedIndicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    return activedIndicatorTotalWidth +
        ((_displayIdicatorsCount - 1) * indicatorTotalWidth);
  }

  double _calculateIndicatorOffset() {
    final indicatorsCountBeforeCentral = (_displayIdicatorsCount - 1) / 2;
    final offset =
        (_indicatorWidth + _indicatorMargin.left + _indicatorMargin.right) *
            (_pageIndex + 999 - indicatorsCountBeforeCentral);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 235,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index % newsrItems.length;
              });
              _scrollController.animateTo(
                _calculateIndicatorOffset(),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
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
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: _indicatorsVisibleWidth,
          height: _indicatorWidth,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final i = index % newsrItems.length;
              return HomeSliderIndicatorItem(
                isActived: index == _pageIndex + 999,
                activedWidth: _activedIndicatorWidth,
                width: _indicatorWidth,
                margin: _indicatorMargin,
              );
            },
          ),
        ),
      ],
    );
  }
}
