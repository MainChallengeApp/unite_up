import 'package:unite_up/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Emoji container for settings cards with rounded square background.
class SettingsEmojiContainer extends StatelessWidget {
  final String emoji;
  final Color backgroundColor;

  const SettingsEmojiContainer({
    super.key,
    required this.emoji,
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
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: AppSizes.iconLarge),
        ),
      ),
    );
  }
}

