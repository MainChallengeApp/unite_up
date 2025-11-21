import 'package:unite_up/enums/challenge_difficulty_enum.dart';
import 'package:unite_up/enums/challenge_status_enum.dart';
import 'package:unite_up/enums/goal_category_enum.dart';

class ChallengeModel {
  final String id;
  final GoalCategoryEnum category;
  final String title;
  final String description;
  final ChallengeDifficultyEnum difficulty;
  final ChallengeStatusEnum status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  ChallengeModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  ChallengeModel copyWith({
    String? id,
    GoalCategoryEnum? category,
    String? title,
    String? description,
    ChallengeDifficultyEnum? difficulty,
    ChallengeStatusEnum? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

