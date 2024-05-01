import 'package:flutter/material.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class HomeSliderIndicatorItem extends StatelessWidget {
  final bool isActived;
  final double activedWidth;
  final double width;
  final EdgeInsets margin;

  const HomeSliderIndicatorItem({
    super.key,
    required this.isActived,
    required this.activedWidth,
    required this.width,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: margin,
        width: isActived ? activedWidth : width,
        decoration: BoxDecoration(
          color:
              isActived ? Theme.of(context).primaryColor : AppColors.porcelain,
          borderRadius: BorderRadius.circular(width),
        ));
  }
}
