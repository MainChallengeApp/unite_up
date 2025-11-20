enum GoalCategoryEnum {
  health(
    'Become Healthier',
    '🏥',
    'Focus on nutrition, sleep, and wellness',
  ),
  social(
    'Improve Social Skills',
    '👥',
    'Build connections and communication skills',
  ),
  intelligence(
    'Become More Intelligent',
    '🧠',
    'Learn new things and expand knowledge',
  ),
  fitness(
    'Get Physically Fit',
    '💪',
    'Build strength and endurance',
  ),
  creativity(
    'Boost Creativity',
    '🎨',
    'Express yourself and think outside the box',
  ),
  productivity(
    'Increase Productivity',
    '⚡',
    'Get more done and manage time better',
  ),
  mindfulness(
    'Practice Mindfulness',
    '🧘',
    'Be present and reduce stress',
  ),
  custom(
    'Custom Goal',
    '⭐',
    'Define your own path to improvement',
  );

  final String displayName;
  final String emoji;
  final String description;

  const GoalCategoryEnum(this.displayName, this.emoji, this.description);
}

