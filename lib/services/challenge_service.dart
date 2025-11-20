import 'dart:math';

import 'package:dare_u/enums/challenge_difficulty_enum.dart';
import 'package:dare_u/enums/challenge_status_enum.dart';
import 'package:dare_u/enums/goal_category_enum.dart';
import 'package:dare_u/models/challenge_model.dart';

class ChallengeService {
  static final Map<GoalCategoryEnum, List<Map<String, dynamic>>> _challengeDatabase = {
    GoalCategoryEnum.health: [
      {'title': 'Drink 8 glasses of water', 'description': 'Stay hydrated throughout the day by drinking at least 8 glasses of water', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Eat 5 servings of vegetables', 'description': 'Include at least 5 different vegetables in your meals today', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Sleep 8 hours tonight', 'description': 'Go to bed early and get a full 8 hours of quality sleep', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'No sugar for 24 hours', 'description': 'Avoid all added sugars and sweet snacks for the entire day', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Take a 30-minute walk', 'description': 'Go for a relaxing 30-minute walk outside', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Meal prep for tomorrow', 'description': 'Prepare healthy meals for tomorrow in advance', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Try a new healthy recipe', 'description': 'Cook a nutritious meal you\'ve never made before', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Meditate for 15 minutes', 'description': 'Practice meditation to reduce stress and improve mental health', 'difficulty': ChallengeDifficultyEnum.easy},
    ],
    GoalCategoryEnum.social: [
      {'title': 'Start a conversation with a stranger', 'description': 'Strike up a friendly conversation with someone new', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Call an old friend', 'description': 'Reach out to a friend you haven\'t talked to in a while', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Give 3 genuine compliments', 'description': 'Make someone\'s day by giving sincere compliments', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Join a group activity', 'description': 'Participate in a local meetup or group event', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Practice active listening', 'description': 'Have a conversation where you really focus on listening', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Share something personal', 'description': 'Open up to someone you trust about how you\'re feeling', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Help someone in need', 'description': 'Offer assistance to someone who could use your help', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Send 5 messages to friends', 'description': 'Reach out to 5 different people just to say hello', 'difficulty': ChallengeDifficultyEnum.easy},
    ],
    GoalCategoryEnum.intelligence: [
      {'title': 'Read 30 pages of a book', 'description': 'Dive into a non-fiction book and read at least 30 pages', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Learn 10 new words', 'description': 'Expand your vocabulary by learning and using 10 new words', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Watch an educational documentary', 'description': 'Watch a full-length educational documentary on a topic that interests you', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Complete an online course module', 'description': 'Finish one module of an online course you\'re taking', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Solve 10 logic puzzles', 'description': 'ChallengeModel your brain with puzzles or brain teasers', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Write a summary of what you learned', 'description': 'Reflect on something new you learned and write about it', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Teach someone something new', 'description': 'Share your knowledge by teaching someone a skill or concept', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Listen to an educational podcast', 'description': 'Learn something new from a podcast episode', 'difficulty': ChallengeDifficultyEnum.easy},
    ],
    GoalCategoryEnum.fitness: [
      {'title': '30 minutes of cardio', 'description': 'Do any cardio exercise for at least 30 minutes', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': '100 push-ups today', 'description': 'Complete 100 push-ups throughout the day (can be in sets)', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Try a new workout', 'description': 'Do a workout routine you\'ve never tried before', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Stretch for 20 minutes', 'description': 'Do a full-body stretching routine', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': '10,000 steps challenge', 'description': 'Walk at least 10,000 steps today', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Plank for 5 minutes total', 'description': 'Hold a plank position for 5 minutes (can be broken up)', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Morning yoga session', 'description': 'Start your day with a 20-minute yoga routine', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Workout with a friend', 'description': 'Exercise together with a friend or workout buddy', 'difficulty': ChallengeDifficultyEnum.medium},
    ],
    GoalCategoryEnum.creativity: [
      {'title': 'Draw for 30 minutes', 'description': 'Spend time drawing or sketching anything you like', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Write a short story', 'description': 'Create a short story with at least 500 words', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Take 20 creative photos', 'description': 'Capture interesting photos using creative angles and compositions', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Learn a new song', 'description': 'Pick up an instrument and learn a new song or melody', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Create something with your hands', 'description': 'Make something physical - origami, craft, sculpture, etc.', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Write in a journal', 'description': 'Express yourself through creative writing in a journal', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Try a new art technique', 'description': 'Experiment with an art medium or technique you haven\'t tried', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Design something', 'description': 'Create a design for anything - logo, poster, room layout, etc.', 'difficulty': ChallengeDifficultyEnum.medium},
    ],
    GoalCategoryEnum.productivity: [
      {'title': 'Complete your top 3 tasks', 'description': 'Identify and complete your 3 most important tasks today', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Organize your workspace', 'description': 'Clean and organize your desk or workspace completely', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Time-block your entire day', 'description': 'Create a detailed schedule with time blocks for all activities', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'No phone for 3 hours', 'description': 'Put your phone away and focus on deep work for 3 hours', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Use Pomodoro technique', 'description': 'Complete 8 Pomodoro sessions (25 min work + 5 min break)', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Declutter one area', 'description': 'Choose one area (drawer, folder, etc.) and declutter it completely', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Plan tomorrow today', 'description': 'Create a detailed plan for tomorrow before you go to bed', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Automate a repetitive task', 'description': 'Find a way to automate or streamline a task you do often', 'difficulty': ChallengeDifficultyEnum.hard},
    ],
    GoalCategoryEnum.mindfulness: [
      {'title': 'Morning meditation', 'description': 'Meditate for 20 minutes first thing in the morning', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Practice gratitude', 'description': 'Write down 10 things you\'re grateful for today', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Mindful eating', 'description': 'Eat one meal today completely mindfully, without distractions', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Digital detox for 4 hours', 'description': 'Stay off all screens and digital devices for 4 hours', 'difficulty': ChallengeDifficultyEnum.hard},
      {'title': 'Nature walk meditation', 'description': 'Take a mindful walk in nature, focusing on your senses', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Body scan meditation', 'description': 'Practice a full body scan meditation for 30 minutes', 'difficulty': ChallengeDifficultyEnum.medium},
      {'title': 'Breathing exercises', 'description': 'Do 15 minutes of focused breathing exercises', 'difficulty': ChallengeDifficultyEnum.easy},
      {'title': 'Evening reflection', 'description': 'Spend 20 minutes reflecting on your day mindfully', 'difficulty': ChallengeDifficultyEnum.medium},
    ],
  };

  static List<ChallengeModel> generateDailyChallenges(GoalCategoryEnum category) {
    final challenges = _challengeDatabase[category] ?? _challengeDatabase[GoalCategoryEnum.health]!;
    final random = Random();
    final selectedChallengeModels = <ChallengeModel>[];
    final usedIndices = <int>{};

    // Generate 3 unique challenges
    while (selectedChallengeModels.length < 3 && usedIndices.length < challenges.length) {
      final index = random.nextInt(challenges.length);
      if (!usedIndices.contains(index)) {
        usedIndices.add(index);
        final challengeData = challenges[index];
        selectedChallengeModels.add(ChallengeModel(
          id: '${DateTime.now().millisecondsSinceEpoch}_$index',
          category: category,
          title: challengeData['title'] as String,
          description: challengeData['description'] as String,
          difficulty: challengeData['difficulty'] as ChallengeDifficultyEnum,
          status: ChallengeStatusEnum.available,
          createdAt: DateTime.now(),
        ));
      }
    }

    return selectedChallengeModels;
  }

  static ChallengeModel generateCustomChallenge(String customGoalName) {
    // For custom goals, provide generic challenges
    final genericChallengeModels = [
      {
        'title': 'Take one step forward',
        'description': 'Do something today that moves you closer to your goal of "$customGoalName"',
        'difficulty': ChallengeDifficultyEnum.medium
      },
      {
        'title': 'Research and learn',
        'description': 'Spend 30 minutes learning about how to achieve "$customGoalName"',
        'difficulty': ChallengeDifficultyEnum.easy
      },
      {
        'title': 'Share your goal',
        'description': 'Tell someone about your goal of "$customGoalName" and why it matters to you',
        'difficulty': ChallengeDifficultyEnum.medium
      },
    ];

    final random = Random();
    final data = genericChallengeModels[random.nextInt(genericChallengeModels.length)];

    return ChallengeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: GoalCategoryEnum.custom,
      title: data['title'] as String,
      description: data['description'] as String,
      difficulty: data['difficulty'] as ChallengeDifficultyEnum,
      status: ChallengeStatusEnum.available,
      createdAt: DateTime.now(),
    );
  }
}

