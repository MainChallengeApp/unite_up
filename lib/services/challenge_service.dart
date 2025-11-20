import 'dart:math';
import '../models/goal.dart';
import '../models/challenge.dart';

class ChallengeService {
  static final Map<GoalCategory, List<Map<String, dynamic>>> _challengeDatabase = {
    GoalCategory.health: [
      {'title': 'Drink 8 glasses of water', 'description': 'Stay hydrated throughout the day by drinking at least 8 glasses of water', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Eat 5 servings of vegetables', 'description': 'Include at least 5 different vegetables in your meals today', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Sleep 8 hours tonight', 'description': 'Go to bed early and get a full 8 hours of quality sleep', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'No sugar for 24 hours', 'description': 'Avoid all added sugars and sweet snacks for the entire day', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Take a 30-minute walk', 'description': 'Go for a relaxing 30-minute walk outside', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Meal prep for tomorrow', 'description': 'Prepare healthy meals for tomorrow in advance', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Try a new healthy recipe', 'description': 'Cook a nutritious meal you\'ve never made before', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Meditate for 15 minutes', 'description': 'Practice meditation to reduce stress and improve mental health', 'difficulty': ChallengeDifficulty.easy},
    ],
    GoalCategory.social: [
      {'title': 'Start a conversation with a stranger', 'description': 'Strike up a friendly conversation with someone new', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Call an old friend', 'description': 'Reach out to a friend you haven\'t talked to in a while', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Give 3 genuine compliments', 'description': 'Make someone\'s day by giving sincere compliments', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Join a group activity', 'description': 'Participate in a local meetup or group event', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Practice active listening', 'description': 'Have a conversation where you really focus on listening', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Share something personal', 'description': 'Open up to someone you trust about how you\'re feeling', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Help someone in need', 'description': 'Offer assistance to someone who could use your help', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Send 5 messages to friends', 'description': 'Reach out to 5 different people just to say hello', 'difficulty': ChallengeDifficulty.easy},
    ],
    GoalCategory.intelligence: [
      {'title': 'Read 30 pages of a book', 'description': 'Dive into a non-fiction book and read at least 30 pages', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Learn 10 new words', 'description': 'Expand your vocabulary by learning and using 10 new words', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Watch an educational documentary', 'description': 'Watch a full-length educational documentary on a topic that interests you', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Complete an online course module', 'description': 'Finish one module of an online course you\'re taking', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Solve 10 logic puzzles', 'description': 'Challenge your brain with puzzles or brain teasers', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Write a summary of what you learned', 'description': 'Reflect on something new you learned and write about it', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Teach someone something new', 'description': 'Share your knowledge by teaching someone a skill or concept', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Listen to an educational podcast', 'description': 'Learn something new from a podcast episode', 'difficulty': ChallengeDifficulty.easy},
    ],
    GoalCategory.fitness: [
      {'title': '30 minutes of cardio', 'description': 'Do any cardio exercise for at least 30 minutes', 'difficulty': ChallengeDifficulty.medium},
      {'title': '100 push-ups today', 'description': 'Complete 100 push-ups throughout the day (can be in sets)', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Try a new workout', 'description': 'Do a workout routine you\'ve never tried before', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Stretch for 20 minutes', 'description': 'Do a full-body stretching routine', 'difficulty': ChallengeDifficulty.easy},
      {'title': '10,000 steps challenge', 'description': 'Walk at least 10,000 steps today', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Plank for 5 minutes total', 'description': 'Hold a plank position for 5 minutes (can be broken up)', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Morning yoga session', 'description': 'Start your day with a 20-minute yoga routine', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Workout with a friend', 'description': 'Exercise together with a friend or workout buddy', 'difficulty': ChallengeDifficulty.medium},
    ],
    GoalCategory.creativity: [
      {'title': 'Draw for 30 minutes', 'description': 'Spend time drawing or sketching anything you like', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Write a short story', 'description': 'Create a short story with at least 500 words', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Take 20 creative photos', 'description': 'Capture interesting photos using creative angles and compositions', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Learn a new song', 'description': 'Pick up an instrument and learn a new song or melody', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Create something with your hands', 'description': 'Make something physical - origami, craft, sculpture, etc.', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Write in a journal', 'description': 'Express yourself through creative writing in a journal', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Try a new art technique', 'description': 'Experiment with an art medium or technique you haven\'t tried', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Design something', 'description': 'Create a design for anything - logo, poster, room layout, etc.', 'difficulty': ChallengeDifficulty.medium},
    ],
    GoalCategory.productivity: [
      {'title': 'Complete your top 3 tasks', 'description': 'Identify and complete your 3 most important tasks today', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Organize your workspace', 'description': 'Clean and organize your desk or workspace completely', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Time-block your entire day', 'description': 'Create a detailed schedule with time blocks for all activities', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'No phone for 3 hours', 'description': 'Put your phone away and focus on deep work for 3 hours', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Use Pomodoro technique', 'description': 'Complete 8 Pomodoro sessions (25 min work + 5 min break)', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Declutter one area', 'description': 'Choose one area (drawer, folder, etc.) and declutter it completely', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Plan tomorrow today', 'description': 'Create a detailed plan for tomorrow before you go to bed', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Automate a repetitive task', 'description': 'Find a way to automate or streamline a task you do often', 'difficulty': ChallengeDifficulty.hard},
    ],
    GoalCategory.mindfulness: [
      {'title': 'Morning meditation', 'description': 'Meditate for 20 minutes first thing in the morning', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Practice gratitude', 'description': 'Write down 10 things you\'re grateful for today', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Mindful eating', 'description': 'Eat one meal today completely mindfully, without distractions', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Digital detox for 4 hours', 'description': 'Stay off all screens and digital devices for 4 hours', 'difficulty': ChallengeDifficulty.hard},
      {'title': 'Nature walk meditation', 'description': 'Take a mindful walk in nature, focusing on your senses', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Body scan meditation', 'description': 'Practice a full body scan meditation for 30 minutes', 'difficulty': ChallengeDifficulty.medium},
      {'title': 'Breathing exercises', 'description': 'Do 15 minutes of focused breathing exercises', 'difficulty': ChallengeDifficulty.easy},
      {'title': 'Evening reflection', 'description': 'Spend 20 minutes reflecting on your day mindfully', 'difficulty': ChallengeDifficulty.medium},
    ],
  };

  static List<Challenge> generateDailyChallenges(GoalCategory category) {
    final challenges = _challengeDatabase[category] ?? _challengeDatabase[GoalCategory.health]!;
    final random = Random();
    final selectedChallenges = <Challenge>[];
    final usedIndices = <int>{};

    // Generate 3 unique challenges
    while (selectedChallenges.length < 3 && usedIndices.length < challenges.length) {
      final index = random.nextInt(challenges.length);
      if (!usedIndices.contains(index)) {
        usedIndices.add(index);
        final challengeData = challenges[index];
        selectedChallenges.add(Challenge(
          id: '${DateTime.now().millisecondsSinceEpoch}_$index',
          category: category,
          title: challengeData['title'] as String,
          description: challengeData['description'] as String,
          difficulty: challengeData['difficulty'] as ChallengeDifficulty,
          status: ChallengeStatus.available,
          createdAt: DateTime.now(),
        ));
      }
    }

    return selectedChallenges;
  }

  static Challenge generateCustomChallenge(String customGoalName) {
    // For custom goals, provide generic challenges
    final genericChallenges = [
      {
        'title': 'Take one step forward',
        'description': 'Do something today that moves you closer to your goal of "$customGoalName"',
        'difficulty': ChallengeDifficulty.medium
      },
      {
        'title': 'Research and learn',
        'description': 'Spend 30 minutes learning about how to achieve "$customGoalName"',
        'difficulty': ChallengeDifficulty.easy
      },
      {
        'title': 'Share your goal',
        'description': 'Tell someone about your goal of "$customGoalName" and why it matters to you',
        'difficulty': ChallengeDifficulty.medium
      },
    ];

    final random = Random();
    final data = genericChallenges[random.nextInt(genericChallenges.length)];

    return Challenge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: GoalCategory.custom,
      title: data['title'] as String,
      description: data['description'] as String,
      difficulty: data['difficulty'] as ChallengeDifficulty,
      status: ChallengeStatus.available,
      createdAt: DateTime.now(),
    );
  }
}

