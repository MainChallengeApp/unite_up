import 'package:dare_u/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Reusable card container with consistent styling across the app.
/// Features: rounded corners, shadow, and theme-aware background color.
class AppCardContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppCardContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.radiusLarge,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: child,
    );
  }
}
