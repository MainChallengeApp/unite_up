import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

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
            color: AppColors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: child,
    );
  }
}
