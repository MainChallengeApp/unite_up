import 'package:dare_u/models/goal_category.dart';

class Goal {
  final String id;
  final GoalCategory category;
  final String? customName;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.category,
    this.customName,
    required this.createdAt,
  });

  String get displayName =>
      category == GoalCategory.custom && customName != null
      ? customName!
      : category.displayName;
}
