import 'package:flutter/material.dart';

import 'package:dare_u/enums/challenge_status_enum.dart';
import 'package:dare_u/models/authenticated_user_model.dart';
import 'package:dare_u/models/challenge_model.dart';
import 'package:dare_u/models/event_model.dart';
import 'package:dare_u/models/goal_model.dart';
import 'package:dare_u/models/progress_entry_model.dart';
import 'package:dare_u/services/auth_service.dart';
import 'package:dare_u/services/challenge_service.dart';

class GoalData {
  final GoalModel goal;
  final List<EventModel> events;
  final List<ChallengeModel> todaysChallenges;
  final ChallengeModel? activeChallenge;

  GoalData({
    required this.goal,
    required this.events,
    required this.todaysChallenges,
    this.activeChallenge,
  });

  GoalData copyWith({
    GoalModel? goal,
    List<EventModel>? events,
    List<ChallengeModel>? todaysChallenges,
    ChallengeModel? activeChallenge,
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
  final AuthService _authService = AuthService();
  final List<GoalData> _goals = [];
  String? _selectedGoalId;
  bool _hasCompletedOnboarding = false;

  // Getters
  AuthenticatedUserModel? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  List<GoalModel> get goals => _goals.map((g) => g.goal).toList();
  GoalModel? get currentGoal => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).goal
      : null;
  List<EventModel> get events => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).events
      : [];
  List<ChallengeModel> get todaysChallenges => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).todaysChallenges
      : [];
  ChallengeModel? get activeChallenge => _selectedGoalId != null
      ? _goals.firstWhere((g) => g.goal.id == _selectedGoalId).activeChallenge
      : null;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasTodaysChallenges => todaysChallenges.isNotEmpty;
  bool get hasActiveChallenge => activeChallenge != null;
  bool get hasGoals => _goals.isNotEmpty;

  // Add a new goal
  void addGoal(GoalModel goal) {
    final events = <EventModel>[];
    
    // Add goal selection event
    events.add(EventModel.goalSelected(goal));
    
    // Add welcome message
    events.add(EventModel.aiMessage(
      'Great choice! 🎉 You\'ve chosen to work on "${goal.displayName}". '
      'I\'ll provide you with daily challenges to help you achieve this goal. '
      'Let\'s get started with today\'s challenges!'
    ));
    
    // Generate challenges
    final challenges = ChallengeService.generateDailyChallenges(goal.category);
    events.add(EventModel.dailyChallengesOffered(challenges));
    
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
  void setGoal(GoalModel goal) {
    addGoal(goal);
  }

  // Select a goal to view
  void selectGoalModel(String goalId) {
    if (_goals.any((g) => g.goal.id == goalId)) {
      _selectedGoalId = goalId;
      notifyListeners();
    }
  }

  // Accept a challenge
  void acceptChallenge(ChallengeModel challenge) {
    if (_selectedGoalId == null) return;
    
    final index = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
    if (index == -1) return;
    
    final updatedChallenge = challenge.copyWith(
      status: ChallengeStatusEnum.accepted,
      acceptedAt: DateTime.now(),
    );
    
    final events = List<EventModel>.from(_goals[index].events);
    events.add(EventModel.challengeAccepted(updatedChallenge));
    events.add(EventModel.aiMessage(
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
  void submitProgress(ProgressEntryModel entry) {
    if (_selectedGoalId == null) return;
    
    final index = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
    if (index == -1 || _goals[index].activeChallenge == null) return;
    
    final events = List<EventModel>.from(_goals[index].events);
    events.add(EventModel.progressSubmitted(entry));
    
    // Mark challenge as completed
    final completedChallenge = _goals[index].activeChallenge!.copyWith(
      status: ChallengeStatusEnum.completed,
      completedAt: DateTime.now(),
    );
    
    events.add(EventModel.challengeCompleted(completedChallenge));
    events.add(EventModel.aiMessage(
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
    
    final events = List<EventModel>.from(_goals[index].events);
    events.add(EventModel.userMessage(message));
    
    _goals[index] = _goals[index].copyWith(events: events);
    notifyListeners();
    
    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      final currentIndex = _goals.indexWhere((g) => g.goal.id == _selectedGoalId);
      if (currentIndex == -1) return;
      
      final updatedEventModels = List<EventModel>.from(_goals[currentIndex].events);
      updatedEventModels.add(EventModel.aiMessage(
        'I appreciate you sharing that! Remember, I\'m here to help you with your challenges. '
        'Keep pushing forward! 🌟'
      ));
      
      _goals[currentIndex] = _goals[currentIndex].copyWith(events: updatedEventModels);
      notifyListeners();
    });
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
    _goals.clear();
    _selectedGoalId = null;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}

