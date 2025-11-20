import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum GoalCategoryEnum {
  health('goals.categories.health', '🏥'),
  social('goals.categories.social', '👥'),
  intelligence('goals.categories.intelligence', '🧠'),
  fitness('goals.categories.fitness', '💪'),
  creativity('goals.categories.creativity', '🎨'),
  productivity('goals.categories.productivity', '⚡'),
  mindfulness('goals.categories.mindfulness', '🧘'),
  custom('goals.categories.custom', '⭐');

  final String translationKey;
  final String emoji;

  const GoalCategoryEnum(this.translationKey, this.emoji);

  String displayName(BuildContext context) {
    return '$translationKey.name'.tr();
  }

  String description(BuildContext context) {
    return '$translationKey.description'.tr();
  }
}
