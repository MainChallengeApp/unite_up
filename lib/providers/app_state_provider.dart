import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../models/challenge.dart';
import '../models/event.dart';
import '../models/progress_entry.dart';
import '../services/challenge_service.dart';

class AppStateProvider extends ChangeNotifier {
  Goal? _currentGoal;
  List<Event> _events = [];
  List<Challenge> _todaysChallenges = [];
  Challenge? _activeChallenge;
  bool _hasCompletedOnboarding = false;

  // Getters
  Goal? get currentGoal => _currentGoal;
  List<Event> get events => List.unmodifiable(_events);
  List<Challenge> get todaysChallenges => List.unmodifiable(_todaysChallenges);
  Challenge? get activeChallenge => _activeChallenge;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasTodaysChallenges => _todaysChallenges.isNotEmpty;
  bool get hasActiveChallenge => _activeChallenge != null;

  // Set goal and complete onboarding
  void setGoal(Goal goal) {
    _currentGoal = goal;
    _hasCompletedOnboarding = true;
    
    // Add goal selection event
    _events.add(Event.goalSelected(goal));
    
    // Add welcome message
    _events.add(Event.aiMessage(
      'Great choice! 🎉 You\'ve chosen to work on "${goal.displayName}". '
      'I\'ll provide you with daily challenges to help you achieve this goal. '
      'Let\'s get started with today\'s challenges!'
    ));
    
    // Generate first set of challenges
    generateDailyChallenges();
    
    notifyListeners();
  }

  // Generate daily challenges
  void generateDailyChallenges() {
    if (_currentGoal == null) return;
    
    _todaysChallenges = ChallengeService.generateDailyChallenges(_currentGoal!.category);
    _events.add(Event.dailyChallengesOffered(_todaysChallenges));
    
    notifyListeners();
  }

  // Accept a challenge
  void acceptChallenge(Challenge challenge) {
    final updatedChallenge = challenge.copyWith(
      status: ChallengeStatus.accepted,
      acceptedAt: DateTime.now(),
    );
    
    _activeChallenge = updatedChallenge;
    _events.add(Event.challengeAccepted(updatedChallenge));
    _events.add(Event.aiMessage(
      'Perfect! You\'ve accepted: "${challenge.title}". '
      'Take your time and upload your progress when you\'re done. You got this! 💪'
    ));
    
    notifyListeners();
  }

  // Submit progress
  void submitProgress(ProgressEntry entry) {
    if (_activeChallenge == null) return;
    
    _events.add(Event.progressSubmitted(entry));
    
    // Mark challenge as completed
    final completedChallenge = _activeChallenge!.copyWith(
      status: ChallengeStatus.completed,
      completedAt: DateTime.now(),
    );
    
    _events.add(Event.challengeCompleted(completedChallenge));
    _events.add(Event.aiMessage(
      'Amazing work! 🎉 You\'ve completed the challenge. '
      'I\'m so proud of you for taking action towards your goal! '
      'Come back tomorrow for new challenges.'
    ));
    
    _activeChallenge = null;
    notifyListeners();
  }

  // Add user message
  void addUserMessage(String message) {
    _events.add(Event.userMessage(message));
    notifyListeners();
    
    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      _events.add(Event.aiMessage(
        'I appreciate you sharing that! Remember, I\'m here to help you with your challenges. '
        'Keep pushing forward! 🌟'
      ));
      notifyListeners();
    });
  }

  // Reset for testing (optional)
  void reset() {
    _currentGoal = null;
    _events = [];
    _todaysChallenges = [];
    _activeChallenge = null;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}

