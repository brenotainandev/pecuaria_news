import 'package:flutter/material.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class BottomNavBarItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final IconData iconData;
  final IconData activeIconData;
  final Function() onTap;
  const BottomNavBarItem({
    super.key,
    required this.text,
    required this.isActive,
    required this.iconData,
    required this.onTap,
    required this.activeIconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : null,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIconData : iconData,
              color: isActive ? AppColors.white : AppColors.osloGrey,
            ),
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 8 : 0,
                height: 1),
            if (isActive)
              Text(
                text,
                style: const TextStyle(color: AppColors.white),
              ),
          ],
        ),
      ),
    );
  }
}
