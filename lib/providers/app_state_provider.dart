import 'package:flutter/material.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/providers/challenges_provider.dart';
import 'package:unite_up/providers/users_provider.dart';

/// Provider for managing app state.
/// Delegates user state to [UsersProvider] and challenge state to [ChallengesProvider].
class AppStateProvider extends ChangeNotifier {
  static const String anonymousUserId = 'user-1';

  UsersProvider? _usersProvider;
  ChallengesProvider? _challengesProvider;
  bool _hasCompletedOnboarding = false;

  /// Update the users provider reference (called by ProxyProvider).
  void updateUsersProvider(UsersProvider usersProvider) {
    if (_usersProvider != usersProvider) {
      _usersProvider = usersProvider;
      _usersProvider?.addListener(_onUserChanged);
    }
  }

  /// Update the challenges provider reference (called by ProxyProvider).
  void updateChallengesProvider(ChallengesProvider challengesProvider) {
    if (_challengesProvider != challengesProvider) {
      _challengesProvider = challengesProvider;
      _challengesProvider?.addListener(_onChallengesChanged);
    }
  }

  void _onUserChanged() {
    // Load challenges when user logs in
    if (_usersProvider?.isAuthenticated == true) {
      _challengesProvider?.loadChallenges();
    } else {
      _challengesProvider?.clear();
    }
    notifyListeners();
  }

  void _onChallengesChanged() {
    if (_challengesProvider?.hasChallenges == true) {
      _hasCompletedOnboarding = true;
    }
    notifyListeners();
  }

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  UserModel? get currentUser => _usersProvider?.currentUser;
  bool get isAuthenticated => _usersProvider?.isAuthenticated ?? false;
  List<ChallengeChatModel> get challenges =>
      _challengesProvider?.challenges ?? [];
  ChallengeChatModel? get currentChallenge =>
      _challengesProvider?.currentChallenge;
  List<EventModel> get events => _challengesProvider?.events ?? [];
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasChallenges => _challengesProvider?.hasChallenges ?? false;
  bool get isLoadingChallenges => _challengesProvider?.isLoading ?? false;
  String? get challengesError => _challengesProvider?.error;

  // ===========================================================================
  // CHALLENGE OPERATIONS (delegate to ChallengesProvider)
  // ===========================================================================

  /// Add a new challenge.
  Future<void> addChallenge(ChallengeChatModel challenge) async {
    await _challengesProvider?.createChallenge(challenge);
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  /// Select a challenge to view.
  void selectChallenge(String challengeId) {
    _challengesProvider?.selectChallenge(challengeId);
  }

  /// Update challenge (for editing).
  Future<void> updateChallenge(ChallengeChatModel challenge) async {
    await _challengesProvider?.updateChallenge(challenge);
  }

  /// Delete challenge.
  Future<void> deleteChallenge(String challengeId) async {
    await _challengesProvider?.deleteChallenge(challengeId);
  }

  // ===========================================================================
  // MESSAGES & EVENTS
  // ===========================================================================

  /// Add user message to current challenge.
  Future<void> addMessage(String message) async {
    await _challengesProvider?.addMessage(message);
  }

  /// Submit progress with attachments.
  Future<void> submitProgress(ProgressEntryModel entry) async {
    await _challengesProvider?.addProgress(entry);
  }

  /// Edit a message.
  Future<void> editMessage(String eventId, String newMessage) async {
    await _challengesProvider?.editMessage(eventId, newMessage);
  }

  /// Delete a message.
  Future<void> deleteMessage(String eventId) async {
    await _challengesProvider?.deleteMessage(eventId);
  }

  // ===========================================================================
  // GOALS
  // ===========================================================================

  /// Add a goal to the current challenge.
  Future<void> addGoal(GoalModel goal) async {
    await _challengesProvider?.addGoal(goal);
  }

  /// Update a goal.
  Future<void> updateGoal(
    GoalModel updatedGoal, {
    bool createEvent = false,
    bool isProgressUpdate = false,
  }) async {
    await _challengesProvider?.updateGoal(
      updatedGoal,
      addEvent: createEvent,
      isProgressUpdate: isProgressUpdate,
    );
  }

  /// Delete a goal.
  Future<void> deleteGoal(String goalId, {bool createEvent = true}) async {
    await _challengesProvider?.deleteGoal(goalId, addEvent: createEvent);
  }

  /// Get goals for a specific user in current challenge.
  List<GoalModel> getGoalsForUser(String userId) {
    return _challengesProvider?.getGoalsForUser(userId) ?? [];
  }

  // ===========================================================================
  // LOADING
  // ===========================================================================

  /// Reload challenges from the database.
  Future<void> reloadChallenges() async {
    await _challengesProvider?.loadChallenges();
  }
}
