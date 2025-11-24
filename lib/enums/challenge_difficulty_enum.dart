import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_colors.dart';

enum ChallengeDifficultyEnum {
  easy('Easy', '🌱', AppColors.green),
  medium('Medium', '🌿', AppColors.orange),
  hard('Hard', '🌳', AppColors.red);

  final String displayName;
  final String emoji;
  final Color color;

  const ChallengeDifficultyEnum(this.displayName, this.emoji, this.color);
}

