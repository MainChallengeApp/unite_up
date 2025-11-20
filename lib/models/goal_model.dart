import 'package:dare_u/enums/goal_category_enum.dart';

class GoalModel {
  final String id;
  final GoalCategoryEnum category;
  final String? customName;
  final DateTime createdAt;

  GoalModel({
    required this.id,
    required this.category,
    this.customName,
    required this.createdAt,
  });

  String get displayName =>
      category == GoalCategoryEnum.custom && customName != null
          ? customName!
          : category.displayName;
}

