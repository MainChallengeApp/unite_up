import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:unite_up/database/challenge_events_database.dart';
import 'package:unite_up/database/challenges_database.dart';
import 'package:unite_up/database/goals_database.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Provider for managing challenges, goals, and events.
class ChallengesProvider extends ChangeNotifier {
  final _challengesDb = ChallengesDatabase.instance;
  final _goalsDb = GoalsDatabase.instance;
  final _eventsDb = ChallengeEventsDatabase.instance;

  List<ChallengeChatModel> _challenges = [];
  String? _selectedChallengeId;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ChallengeChatModel> get challenges => _challenges;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasChallenges => _challenges.isNotEmpty;

  ChallengeChatModel? get currentChallenge => _selectedChallengeId != null
      ? _challenges.firstWhere(
          (c) => c.id == _selectedChallengeId,
          orElse: () => _challenges.first,
        )
      : null;

  List<EventModel> get events => currentChallenge?.events ?? [];

  String? get currentUserId => SupabaseService.currentUser?.id;

  @override
  void dispose() {
    // Clean up realtime subscriptions
    _eventsDb.unsubscribeAll();
    super.dispose();
  }

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  /// Load all challenges for the current user.
  Future<void> loadChallenges() async {
    if (currentUserId == null) {
      _challenges = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _challenges = await _challengesDb.getForCurrentUser();
      _isLoading = false;

      // If we have a selected challenge, resubscribe to it
      if (_selectedChallengeId != null &&
          _challenges.any((c) => c.id == _selectedChallengeId)) {
        _subscribeToChallenge(_selectedChallengeId!);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear challenges (call on logout).
  Future<void> clear() async {
    // Unsubscribe from all realtime channels
    await _eventsDb.unsubscribeAll();

    _challenges = [];
    _selectedChallengeId = null;
    _error = null;
    notifyListeners();
  }

  // ===========================================================================
  // CHALLENGE CRUD
  // ===========================================================================

  /// Create a new challenge.
  Future<ChallengeChatModel?> createChallenge(
    ChallengeChatModel challenge,
  ) async {
    developer.log(
      'Creating challenge: ${challenge.name}',
      name: 'ChallengesProvider',
    );
    developer.log(
      'Creator ID: ${challenge.creatorId}',
      name: 'ChallengesProvider',
    );
    developer.log(
      'Current user ID: $currentUserId',
      name: 'ChallengesProvider',
    );

    try {
      final created = await _challengesDb.create(challenge);
      developer.log(
        'Challenge created with ID: ${created.id}',
        name: 'ChallengesProvider',
      );

      final refreshed = await _challengesDb.getById(created.id);
      if (refreshed != null) {
        _challenges.insert(0, refreshed);

        // Unsubscribe from previous challenge and subscribe to new one
        await _unsubscribeFromCurrentChallenge();
        _selectedChallengeId = refreshed.id;
        _subscribeToChallenge(refreshed.id);

        notifyListeners();
        return refreshed;
      }

      return created;
    } catch (e, stackTrace) {
      developer.log(
        'Error creating challenge: $e',
        name: 'ChallengesProvider',
        error: e,
        stackTrace: stackTrace,
      );
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Select a challenge to view.
  void selectChallenge(String challengeId) {
    if (_challenges.any((c) => c.id == challengeId)) {
      // Unsubscribe from previous challenge
      _unsubscribeFromCurrentChallenge();

      _selectedChallengeId = challengeId;

      // Subscribe to realtime updates for this challenge
      _subscribeToChallenge(challengeId);

      notifyListeners();
    }
  }

  /// Subscribe to realtime updates for a challenge.
  void _subscribeToChallenge(String challengeId) {
    _eventsDb.subscribeToChallenge(
      challengeId,
      onInsert: _handleEventInsert,
      onUpdate: _handleEventUpdate,
      onDelete: _handleEventDelete,
    );

    developer.log(
      'Subscribed to realtime updates for challenge: $challengeId',
      name: 'ChallengesProvider',
    );
  }

  /// Unsubscribe from current challenge realtime updates.
  Future<void> _unsubscribeFromCurrentChallenge() async {
    if (_selectedChallengeId != null) {
      await _eventsDb.unsubscribeFromChallenge(_selectedChallengeId!);
    }
  }

  /// Handle a new event inserted via realtime.
  void _handleEventInsert(EventModel event) {
    developer.log(
      'Realtime: New event received - ${event.type}',
      name: 'ChallengesProvider',
    );

    // Find the challenge and add the event
    final index = _challenges.indexWhere((c) => c.id == event.challengeId);
    if (index != -1) {
      final challenge = _challenges[index];

      // Check if event already exists (avoid duplicates)
      if (!challenge.events.any((e) => e.id == event.id)) {
        final updatedEvents = [...challenge.events, event];
        _challenges[index] = challenge.copyWith(events: updatedEvents);
        notifyListeners();
      }
    }
  }

  /// Handle an event updated via realtime.
  void _handleEventUpdate(EventModel event) {
    developer.log(
      'Realtime: Event updated - ${event.id}',
      name: 'ChallengesProvider',
    );

    // Find the challenge and update the event
    final challengeIndex = _challenges.indexWhere(
      (c) => c.id == event.challengeId,
    );
    if (challengeIndex != -1) {
      final challenge = _challenges[challengeIndex];
      final eventIndex = challenge.events.indexWhere((e) => e.id == event.id);

      if (eventIndex != -1) {
        final updatedEvents = List<EventModel>.from(challenge.events);
        updatedEvents[eventIndex] = event;
        _challenges[challengeIndex] = challenge.copyWith(events: updatedEvents);
        notifyListeners();
      }
    }
  }

  /// Handle an event deleted via realtime.
  void _handleEventDelete(String eventId) {
    developer.log(
      'Realtime: Event deleted - $eventId',
      name: 'ChallengesProvider',
    );

    // Find and remove the event from all challenges
    for (int i = 0; i < _challenges.length; i++) {
      final challenge = _challenges[i];
      final eventIndex = challenge.events.indexWhere((e) => e.id == eventId);

      if (eventIndex != -1) {
        final updatedEvents = List<EventModel>.from(challenge.events)
          ..removeAt(eventIndex);
        _challenges[i] = challenge.copyWith(events: updatedEvents);
        notifyListeners();
        break;
      }
    }
  }

  /// Update a challenge.
  Future<void> updateChallenge(ChallengeChatModel challenge) async {
    try {
      final updated = await _challengesDb.update(
        challenge.id,
        challenge.toUpdateJson(),
      );

      final index = _challenges.indexWhere((c) => c.id == challenge.id);
      if (index != -1) {
        _challenges[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a challenge.
  Future<void> deleteChallenge(String challengeId) async {
    try {
      await _challengesDb.delete(challengeId);
      _challenges.removeWhere((c) => c.id == challengeId);
      if (_selectedChallengeId == challengeId) {
        _selectedChallengeId = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================================================================
  // MEMBERS
  // ===========================================================================

  /// Add members to a challenge.
  Future<void> addMembers(String challengeId, List<String> userIds) async {
    try {
      for (final userId in userIds) {
        await _challengesDb.addMember(challengeId, userId);
      }
      await _refreshChallenge(challengeId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Remove a member from a challenge.
  Future<void> removeMember(String challengeId, String userId) async {
    try {
      await _challengesDb.removeMember(challengeId, userId);
      await _refreshChallenge(challengeId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================================================================
  // GOALS
  // ===========================================================================

  /// Add a goal to the current challenge.
  Future<GoalModel?> addGoal(GoalModel goal) async {
    if (_selectedChallengeId == null) return null;

    try {
      final created = await _goalsDb.create(goal);

      // Add event for goal creation
      final event = EventModel.goalCreated(created, userId: currentUserId);
      await _eventsDb.create(event);

      await _refreshChallenge(_selectedChallengeId!);
      return created;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update a goal.
  Future<void> updateGoal(
    GoalModel updatedGoal, {
    bool addEvent = true,
    bool isProgressUpdate = false,
  }) async {
    if (_selectedChallengeId == null) return;

    try {
      // Get old goal for comparison
      final challengeIndex = _challenges.indexWhere(
        (c) => c.id == _selectedChallengeId,
      );
      if (challengeIndex == -1) return;

      final oldGoal = _challenges[challengeIndex].goals.firstWhere(
        (g) => g.id == updatedGoal.id,
      );

      // Update in database
      final response = await _goalsDb.update(updatedGoal.id, {
        'title': updatedGoal.title,
        'start_value': updatedGoal.startValue,
        'end_value': updatedGoal.endValue,
        'current_value': updatedGoal.currentValue,
        'start_date': updatedGoal.startDate.toIso8601String(),
        'end_date': updatedGoal.endDate.toIso8601String(),
        'unit': updatedGoal.unit,
      });

      // Add event if needed
      if (addEvent) {
        final wasCompleted = oldGoal.isCompleted;
        final isNowCompleted = response.isCompleted;
        final justCompleted = !wasCompleted && isNowCompleted;

        EventModel event;
        if (isProgressUpdate) {
          event = EventModel.goalProgressUpdated(
            response,
            userId: currentUserId,
          );
        } else {
          event = EventModel.goalUpdated(
            oldGoal,
            response,
            completedByUpdate: justCompleted,
            userId: currentUserId,
          );
        }
        await _eventsDb.create(event);
      }

      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a goal.
  Future<void> deleteGoal(String goalId, {bool addEvent = true}) async {
    if (_selectedChallengeId == null) return;

    try {
      // Get goal for event
      final challengeIndex = _challenges.indexWhere(
        (c) => c.id == _selectedChallengeId,
      );
      if (challengeIndex == -1) return;

      final goal = _challenges[challengeIndex].goals.firstWhere(
        (g) => g.id == goalId,
      );

      // Add event before deleting
      if (addEvent) {
        final event = EventModel.goalDeleted(goal, userId: currentUserId);
        await _eventsDb.create(event);
      }

      await _goalsDb.delete(goalId);
      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Get goals for a specific user in current challenge.
  List<GoalModel> getGoalsForUser(String userId) {
    if (_selectedChallengeId == null) return [];

    final challenge = _challenges.firstWhere(
      (c) => c.id == _selectedChallengeId,
      orElse: () => _challenges.first,
    );

    return challenge.goals.where((g) => g.userId == userId).toList();
  }

  // ===========================================================================
  // EVENTS (MESSAGES)
  // ===========================================================================

  /// Add a user message to current challenge.
  Future<void> addMessage(String message) async {
    if (_selectedChallengeId == null) return;

    try {
      final event = EventModel.userMessage(
        _selectedChallengeId!,
        message,
        userId: currentUserId,
      );
      await _eventsDb.create(event);
      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Add a progress entry to current challenge.
  Future<void> addProgress(ProgressEntryModel entry) async {
    if (_selectedChallengeId == null) return;

    try {
      final event = EventModel.progressSubmitted(
        _selectedChallengeId!,
        entry,
        userId: currentUserId,
      );
      await _eventsDb.create(event);
      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Edit a message.
  Future<void> editMessage(String eventId, String newMessage) async {
    if (_selectedChallengeId == null) return;

    try {
      await _eventsDb.updateMessage(eventId, newMessage);
      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a message.
  Future<void> deleteMessage(String eventId) async {
    if (_selectedChallengeId == null) return;

    try {
      await _eventsDb.delete(eventId);
      await _refreshChallenge(_selectedChallengeId!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  Future<void> _refreshChallenge(String challengeId) async {
    final refreshed = await _challengesDb.getById(challengeId);
    if (refreshed != null) {
      final index = _challenges.indexWhere((c) => c.id == challengeId);
      if (index != -1) {
        _challenges[index] = refreshed;
      } else {
        _challenges.add(refreshed);
      }
      notifyListeners();
    }
  }
}
