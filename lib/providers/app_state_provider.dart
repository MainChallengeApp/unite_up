import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../models/challenge.dart';
import '../models/event.dart';
import '../models/progress_entry.dart';
import '../services/challenge_service.dart';

class GoalData {
  final Goal goal;
  final List<Event> events;
  final List<Challenge> todaysChallenges;
  final Challenge? activeChallenge;

  GoalData({
    required this.goal,
    required this.events,
    required this.todaysChallenges,
    this.activeChallenge,
  });

  GoalData copyWith({
    Goal? goal,
    List<Event>? events,
    List<Challenge>? todaysChallenges,
    Challenge? activeChallenge,
    bool clearActiveChallenge = false,
  }) {
    return GoalData(
      goal: goal ?? this.goal,
      events: events ?? this.events,
      todaysChallenges: todaysChallenges ?? this.todaysChallenges,
      activeChallenge:
          clearActiveChallenge ? null : (activeChallenge ?? this.activeChallenge),
    );
  }
}

class AppStateProvider extends ChangeNotifier {
  final List<GoalData> _goals = [];
  String? _selectedGoalId;
  bool _hasCompletedOnboarding = false;

  // Getters
  List<Goal> get goals => _goals.map((g) => g.goal).toList();
  Goal? get currentGoal => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).goal
      : null;
  List<Event> get events => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).events
      : [];
  List<Challenge> get todaysChallenges => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).todaysChallenges
      : [];
  Challenge? get activeChallenge => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).activeChallenge
      : null;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasTodaysChallenges => todaysChallenges.isNotEmpty;
  bool get hasActiveChallenge => activeChallenge != null;
  bool get hasGoals => _goals.isNotEmpty;

  // Add a new goal
  void addGoal(Goal goal) {
    final events = <Event>[];
    
    // Add goal selection event
    events.add(Event.goalSelected(goal));
    
    // Add welcome message
    events.add(Event.aiMessage(
      'Great choice! 🎉 You\'ve chosen to work on "${goal.displayName}". '
      'I\'ll provide you with daily challenges to help you achieve this goal. '
      'Let\'s get started with today\'s challenges!'
    ));
    
    // Generate challenges
    final challenges = ChallengeService.generateDailyChallenges(goal.category);
    events.add(Event.dailyChallengesOffered(challenges));
    
    final goalData = GoalData(
      goal: goal,
      events: events,
      todaysChallenges: challenges,
    );
    
    _goals.add(goalData);
    _selectedGoalId = goal.id;
    _hasCompletedOnboarding = true;
    
    notifyListeners();
  }

  // Set goal and complete onboarding (for onboarding flow)
  void setGoal(Goal goal) {
    addGoal(goal);
  }

  // Select a goal to view
  void selectGoal(String goalId) {
    if (_goals.any((g) => g.goal.id == goalId)) {
      _selectedGoalId = goalId;
      notifyListeners();
    }
  }

  // Accept a challenge
  void acceptChallenge(Challenge challenge) {
    if (_selectedGoalId == null) return;
    
    final index = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
    if (index == -1) return;
    
    final updatedChallenge = challenge.copyWith(
      status: ChallengeStatus.accepted,
      acceptedAt: DateTime.now(),
    );
    
    final events = List<Event>.from(_goals[index].events);
    events.add(Event.challengeAccepted(updatedChallenge));
    events.add(Event.aiMessage(
      'Perfect! You\'ve accepted: "${challenge.title}". '
      'Take your time and upload your progress when you\'re done. You got this! 💪'
    ));
    
    _goals[index] = _goals[index].copyWith(
      events: events,
      activeChallenge: updatedChallenge,
    );
    
    notifyListeners();
  }

  // Submit progress
  void submitProgress(ProgressEntry entry) {
    if (_selectedGoalId == null) return;
    
    final index = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
    if (index == -1 || _goals[index].activeChallenge == null) return;
    
    final events = List<Event>.from(_goals[index].events);
    events.add(Event.progressSubmitted(entry));
    
    // Mark challenge as completed
    final completedChallenge = _goals[index].activeChallenge!.copyWith(
      status: ChallengeStatus.completed,
      completedAt: DateTime.now(),
    );
    
    events.add(Event.challengeCompleted(completedChallenge));
    events.add(Event.aiMessage(
      'Amazing work! 🎉 You\'ve completed the challenge. '
      'I\'m so proud of you for taking action towards your goal! '
      'Come back tomorrow for new challenges.'
    ));
    
    _goals[index] = _goals[index].copyWith(
      events: events,
      clearActiveChallenge: true,
    );
    
    notifyListeners();
  }

  // Add user message
  void addUserMessage(String message) {
    if (_selectedGoalId == null) return;
    
    final index = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
    if (index == -1) return;
    
    final events = List<Event>.from(_goals[index].events);
    events.add(Event.userMessage(message));
    
    _goals[index] = _goals[index].copyWith(events: events);
    notifyListeners();
    
    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      final currentIndex = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
      if (currentIndex == -1) return;
      
      final updatedEvents = List<Event>.from(_goals[currentIndex].events);
      updatedEvents.add(Event.aiMessage(
        'I appreciate you sharing that! Remember, I\'m here to help you with your challenges. '
        'Keep pushing forward! 🌟'
      ));
      
      _goals[currentIndex] = _goals[currentIndex].copyWith(events: updatedEvents);
      notifyListeners();
    });
  }

  // Reset for testing (optional)
  void reset() {
    _goals.clear();
    _selectedGoalId = null;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}

