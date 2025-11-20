import 'package:flutter/material.dart';

enum ChallengeDifficultyEnum {
  easy('Easy', '🌱', Colors.green),
  medium('Medium', '🌿', Colors.orange),
  hard('Hard', '🌳', Colors.red);

  final String displayName;
  final String emoji;
  final Color color;

  const ChallengeDifficultyEnum(this.displayName, this.emoji, this.color);
}

