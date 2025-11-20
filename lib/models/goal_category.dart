enum GoalCategory {
  health,
  social,
  intelligence,
  fitness,
  creativity,
  productivity,
  mindfulness,
  custom;

  String get displayName {
    switch (this) {
      case GoalCategory.health:
        return 'Become Healthier';
      case GoalCategory.social:
        return 'Improve Social Skills';
      case GoalCategory.intelligence:
        return 'Become More Intelligent';
      case GoalCategory.fitness:
        return 'Get Physically Fit';
      case GoalCategory.creativity:
        return 'Boost Creativity';
      case GoalCategory.productivity:
        return 'Increase Productivity';
      case GoalCategory.mindfulness:
        return 'Practice Mindfulness';
      case GoalCategory.custom:
        return 'Custom Goal';
    }
  }

  String get emoji {
    switch (this) {
      case GoalCategory.health:
        return '🏥';
      case GoalCategory.social:
        return '👥';
      case GoalCategory.intelligence:
        return '🧠';
      case GoalCategory.fitness:
        return '💪';
      case GoalCategory.creativity:
        return '🎨';
      case GoalCategory.productivity:
        return '⚡';
      case GoalCategory.mindfulness:
        return '🧘';
      case GoalCategory.custom:
        return '⭐';
    }
  }

  String get description {
    switch (this) {
      case GoalCategory.health:
        return 'Focus on nutrition, sleep, and wellness';
      case GoalCategory.social:
        return 'Build connections and communication skills';
      case GoalCategory.intelligence:
        return 'Learn new things and expand knowledge';
      case GoalCategory.fitness:
        return 'Build strength and endurance';
      case GoalCategory.creativity:
        return 'Express yourself and think outside the box';
      case GoalCategory.productivity:
        return 'Get more done and manage time better';
      case GoalCategory.mindfulness:
        return 'Be present and reduce stress';
      case GoalCategory.custom:
        return 'Define your own path to improvement';
    }
  }
}
