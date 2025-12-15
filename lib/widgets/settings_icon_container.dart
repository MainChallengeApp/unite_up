import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

/// Icon container for settings cards with rounded square background.
class SettingsIconContainer extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;

  const SettingsIconContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.containerSmall,
      height: AppSizes.containerSmall,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: AppOpacity.veryLight),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Icon(
        icon,
        color:
            color ??
            Theme.of(
              context,
            ).iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque) ??
            Theme.of(context).colorScheme.primary,
        size: AppSizes.iconLarge,
      ),
    );
  }
}
