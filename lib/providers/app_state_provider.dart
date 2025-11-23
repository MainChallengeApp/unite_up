import 'package:flutter/material.dart';

import 'package:unite_up/models/authenticated_user_model.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/services/auth_service.dart';

class AppStateProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final List<ChallengeChatModel> _challenges = [];
  String? _selectedChallengeId;
  bool _hasCompletedOnboarding = false;

  // Getters
  AuthenticatedUserModel? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  List<ChallengeChatModel> get challenges => _challenges;
  ChallengeChatModel? get currentChallenge => _selectedChallengeId != null
      ? _challenges.firstWhere((c) => c.id == _selectedChallengeId)
      : null;
  List<EventModel> get events =>
      currentChallenge?.events ?? [];
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasChallenges => _challenges.isNotEmpty;

  // Add a new challenge
  void addChallenge(ChallengeChatModel challenge) {
    final events = <EventModel>[];

    // Add welcome message for personal challenges
    if (challenge.isPersonal) {
      events.add(EventModel.aiMessage(
        'Great choice! 🎉 You\'ve created "${challenge.name}". '
        'Use this space to document your progress, add updates, and track your journey. '
        'Let\'s get started!'
      ));
    } else {
      events.add(EventModel.aiMessage(
        'Welcome to "${challenge.name}"! 👥 '
        'This group challenge has ${challenge.memberCount} members. '
        'Share your progress, encourage each other, and achieve your goals together!'
      ));
    }

    final challengeWithEvents = challenge.copyWith(events: events);
    _challenges.add(challengeWithEvents);
    _selectedChallengeId = challenge.id;
    _hasCompletedOnboarding = true;

    notifyListeners();
  }

  // Select a challenge to view
  void selectChallenge(String challengeId) {
    if (_challenges.any((c) => c.id == challengeId)) {
      _selectedChallengeId = challengeId;
      notifyListeners();
    }
  }

  // Add user message to current challenge
  void addMessage(String message) {
    if (_selectedChallengeId == null) return;

    final index = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (index == -1) return;

    final events = List<EventModel>.from(_challenges[index].events);
    events.add(EventModel.userMessage(message));

    _challenges[index] = _challenges[index].copyWith(events: events);
    notifyListeners();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      final currentIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
      if (currentIndex == -1) return;

      final updatedEvents = List<EventModel>.from(_challenges[currentIndex].events);
      updatedEvents.add(EventModel.aiMessage(
        'Thanks for sharing! Keep documenting your progress. You\'re doing great! 🌟'
      ));

      _challenges[currentIndex] = _challenges[currentIndex].copyWith(events: updatedEvents);
      notifyListeners();
    });
  }

  // Submit progress with attachments
  void submitProgress(ProgressEntryModel entry) {
    if (_selectedChallengeId == null) return;

    final index = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (index == -1) return;

    final events = List<EventModel>.from(_challenges[index].events);
    events.add(EventModel.progressSubmitted(entry));

    events.add(EventModel.aiMessage(
      'Amazing progress! 🎉 Thanks for documenting your journey. '
      'Keep up the great work!'
    ));

    _challenges[index] = _challenges[index].copyWith(events: events);
    notifyListeners();
  }

  // Edit a message
  void editMessage(String eventId, String newMessage) {
    if (_selectedChallengeId == null) return;

    final challengeIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (challengeIndex == -1) return;

    final events = List<EventModel>.from(_challenges[challengeIndex].events);
    final eventIndex = events.indexWhere((e) => e.id == eventId);
    
    if (eventIndex != -1) {
      events[eventIndex] = events[eventIndex].copyWith(message: newMessage);
      _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(events: events);
      notifyListeners();
    }
  }

  // Delete a message
  void deleteMessage(String eventId) {
    if (_selectedChallengeId == null) return;

    final challengeIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (challengeIndex == -1) return;

    final events = List<EventModel>.from(_challenges[challengeIndex].events);
    events.removeWhere((e) => e.id == eventId);
    
    _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(events: events);
    notifyListeners();
  }

  // Add a goal to the current challenge
  void addGoal(GoalModel goal) {
    if (_selectedChallengeId == null) return;

    final challengeIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (challengeIndex == -1) return;

    final goals = List<GoalModel>.from(_challenges[challengeIndex].goals);
    goals.add(goal);

    // Add chat event for goal creation
    final events = List<EventModel>.from(_challenges[challengeIndex].events);
    events.add(EventModel.goalCreated(goal));

    _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(
      goals: goals,
      events: events,
    );
    notifyListeners();
  }

  // Update a goal
  void updateGoal(GoalModel updatedGoal, {bool createEvent = false}) {
    if (_selectedChallengeId == null) return;

    final challengeIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (challengeIndex == -1) return;

    final goals = List<GoalModel>.from(_challenges[challengeIndex].goals);
    final goalIndex = goals.indexWhere((g) => g.id == updatedGoal.id);

    if (goalIndex != -1) {
      goals[goalIndex] = updatedGoal;
      
      // Optionally add chat event for progress update
      if (createEvent) {
        final events = List<EventModel>.from(_challenges[challengeIndex].events);
        events.add(EventModel.goalProgressUpdated(updatedGoal));
        _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(
          goals: goals,
          events: events,
        );
      } else {
        _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(goals: goals);
      }
      
      notifyListeners();
    }
  }

  // Delete a goal
  void deleteGoal(String goalId) {
    if (_selectedChallengeId == null) return;

    final challengeIndex = _challenges.indexWhere((c) => c.id == _selectedChallengeId);
    if (challengeIndex == -1) return;

    final goals = List<GoalModel>.from(_challenges[challengeIndex].goals);
    goals.removeWhere((g) => g.id == goalId);

    _challenges[challengeIndex] = _challenges[challengeIndex].copyWith(goals: goals);
    notifyListeners();
  }

  // Get goals for a specific user in current challenge
  List<GoalModel> getGoalsForUser(String userId) {
    if (_selectedChallengeId == null) return [];

    final challenge = _challenges.firstWhere(
      (c) => c.id == _selectedChallengeId,
      orElse: () => _challenges.first,
    );

    return challenge.goals.where((g) => g.userId == userId).toList();
  }

  // Update challenge (for editing)
  void updateChallenge(ChallengeChatModel challenge) {
    final index = _challenges.indexWhere((c) => c.id == challenge.id);
    if (index != -1) {
      _challenges[index] = challenge;
      notifyListeners();
    }
  }

  // Delete challenge
  void deleteChallenge(String challengeId) {
    _challenges.removeWhere((c) => c.id == challengeId);
    if (_selectedChallengeId == challengeId) {
      _selectedChallengeId = null;
    }
    notifyListeners();
  }

  // Authentication methods
  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    await _authService.signInWithApple();
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    await _authService.signUpWithEmail(email, password, name);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  // Reset for testing (optional)
  void reset() {
    _challenges.clear();
    _selectedChallengeId = null;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}
