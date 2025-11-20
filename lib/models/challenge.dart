import 'goal.dart';

enum ChallengeStatus {
  available,
  accepted,
  completed,
  skipped;
}

enum ChallengeDifficulty {
  easy,
  medium,
  hard;

  String get displayName {
    switch (this) {
      case ChallengeDifficulty.easy:
        return 'Easy';
      case ChallengeDifficulty.medium:
        return 'Medium';
      case ChallengeDifficulty.hard:
        return 'Hard';
    }
  }

  String get emoji {
    switch (this) {
      case ChallengeDifficulty.easy:
        return '🌱';
      case ChallengeDifficulty.medium:
        return '🌿';
      case ChallengeDifficulty.hard:
        return '🌳';
    }
  }
}

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

