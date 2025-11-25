import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class CustomSlidableActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double iconSize;

  const CustomSlidableActionButton({
    super.key,
    required this.icon,
    required this.color,
    this.iconSize = AppSizes.iconMedium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Center(
        child: Icon(
          icon,
          color: AppColors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

