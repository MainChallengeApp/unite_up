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
