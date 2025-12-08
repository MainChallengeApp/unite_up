import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_colors.dart';
import 'package:unite_up/core/constants/app_opacity.dart';
import 'package:unite_up/core/constants/app_sizes.dart';

/// Centralized text style constants for the UniteUp app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Base text styles (no color - to be combined with theme colors)
  static const TextStyle baseSmall = TextStyle(fontSize: AppSizes.fontSmall);
  static const TextStyle baseRegular = TextStyle(
    fontSize: AppSizes.fontRegular,
  );
  static const TextStyle baseMedium = TextStyle(fontSize: AppSizes.fontMedium);
  static const TextStyle baseBase = TextStyle(fontSize: AppSizes.fontBase);
  static const TextStyle baseLarge = TextStyle(fontSize: AppSizes.fontLarge);
  static const TextStyle baseXLarge = TextStyle(fontSize: AppSizes.fontXLarge);
  static const TextStyle baseXXLarge = TextStyle(
    fontSize: AppSizes.fontXXLarge,
  );
  static const TextStyle baseHuge = TextStyle(fontSize: AppSizes.fontHuge);

  // Semibold text styles (w600)
  static const TextStyle smallSemiBold = TextStyle(
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle regularSemiBold = TextStyle(
    fontSize: AppSizes.fontRegular,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle mediumSemiBold = TextStyle(
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle baseSemiBold = TextStyle(
    fontSize: AppSizes.fontBase,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle largeSemiBold = TextStyle(
    fontSize: AppSizes.fontLarge,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle xLargeSemiBold = TextStyle(
    fontSize: AppSizes.fontXLarge,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle xxLargeSemiBold = TextStyle(
    fontSize: AppSizes.fontXXLarge,
    fontWeight: FontWeight.w600,
  );

  // Bold text styles
  static const TextStyle smallBold = TextStyle(
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle regularBold = TextStyle(
    fontSize: AppSizes.fontRegular,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle mediumBold = TextStyle(
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle baseBold = TextStyle(
    fontSize: AppSizes.fontBase,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle largeBold = TextStyle(
    fontSize: AppSizes.fontLarge,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle xLargeBold = TextStyle(
    fontSize: AppSizes.fontXLarge,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle xxLargeBold = TextStyle(
    fontSize: AppSizes.fontXXLarge,
    fontWeight: FontWeight.bold,
  );

  // Medium text styles (w500)
  static const TextStyle smallMedium = TextStyle(
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle regularMedium = TextStyle(
    fontSize: AppSizes.fontRegular,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle mediumWeight = TextStyle(
    fontSize: AppSizes.fontMedium,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle baseMediumWeight = TextStyle(
    fontSize: AppSizes.fontBase,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle largeMedium = TextStyle(
    fontSize: AppSizes.fontLarge,
    fontWeight: FontWeight.w500,
  );

  // Emoji text styles
  static const TextStyle emojiSmall = TextStyle(fontSize: AppSizes.emojiSmall);
  static const TextStyle emojiMedium = TextStyle(
    fontSize: AppSizes.emojiMedium,
  );
  static const TextStyle emojiLarge = TextStyle(fontSize: AppSizes.emojiLarge);
  static const TextStyle emojiXLarge = TextStyle(
    fontSize: AppSizes.emojiXLarge,
  );
  static const TextStyle emojiHuge = TextStyle(fontSize: AppSizes.emojiHuge);

  // Title styles - common for headers and titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  // Helper methods to create theme-aware text styles
  static TextStyle primaryText(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: theme.brightness == Brightness.dark
          ? AppColors.white
          : AppColors.darkSurface,
    );
  }

  static TextStyle secondaryText(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    double? alpha,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: theme.iconTheme.color?.withValues(
        alpha: alpha ?? AppOpacity.mostlyOpaque,
      ),
    );
  }

  static TextStyle hintText(BuildContext context, {double? fontSize}) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      color: theme.iconTheme.color?.withValues(
        alpha: AppOpacity.semiTransparent,
      ),
    );
  }

  static TextStyle primaryColorText(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: theme.colorScheme.primary,
    );
  }

  // Common specific text styles with colors
  static TextStyle largeSemiBoldPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: AppSizes.fontLarge,
      fontWeight: FontWeight.w600,
      color: theme.brightness == Brightness.dark
          ? AppColors.white
          : AppColors.darkSurface,
    );
  }

  static TextStyle mediumSemiBoldPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: AppSizes.fontMedium,
      fontWeight: FontWeight.w600,
      color: theme.brightness == Brightness.dark
          ? AppColors.white
          : AppColors.darkSurface,
    );
  }

  static TextStyle regularSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: AppSizes.fontRegular,
      color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
    );
  }

  static TextStyle smallSecondary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: AppSizes.fontSmall,
      color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
    );
  }

  static TextStyle baseTextPrimary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: AppSizes.fontBase,
      color: theme.brightness == Brightness.dark
          ? AppColors.white
          : AppColors.darkSurface,
    );
  }
}
