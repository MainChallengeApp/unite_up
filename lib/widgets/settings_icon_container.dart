import 'package:dare_u/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Icon container for settings cards with rounded square background.
class SettingsIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const SettingsIconContainer({
    super.key,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.containerSmall,
      height: AppSizes.containerSmall,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Icon(
        icon,
        color: color,
        size: AppSizes.iconLarge,
      ),
    );
  }
}

