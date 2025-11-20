import 'package:dare_u/models/challenge_difficulty.dart';
import 'package:dare_u/models/challenge_status.dart';
import 'package:dare_u/models/goal_category.dart';

class Challenge {
  final String id;
  final GoalCategory category;
  final String title;
  final String description;
  final ChallengeDifficulty difficulty;
  final ChallengeStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  Challenge({
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

  Challenge copyWith({
    String? id,
    GoalCategory? category,
    String? title,
    String? description,
    ChallengeDifficulty? difficulty,
    ChallengeStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return Challenge(
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
