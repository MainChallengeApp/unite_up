import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Database operations for the challenges table.
class ChallengesDatabase {
  ChallengesDatabase._();

  static final ChallengesDatabase _instance = ChallengesDatabase._();
  static ChallengesDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'challenges';
  static const String _membersTable = 'challenge_members';

  /// Create a new challenge with members.
  Future<ChallengeChatModel> create(ChallengeChatModel challenge) async {
    final response = await _client
        .from(_tableName)
        .insert(challenge.toJson())
        .select()
        .single();

    final challengeId = response['id'] as String;

    // Creator is automatically added as member via trigger
    // Now add any additional members (excluding the creator who's already added)
    final additionalMembers = challenge.memberIds
        .where((id) => id != challenge.creatorId)
        .toList();

    for (final memberId in additionalMembers) {
      await _client.from(_membersTable).insert({
        'challenge_id': challengeId,
        'user_id': memberId,
        'role': 'member',
      });
    }

    // Return with all member IDs
    final allMemberIds = [challenge.creatorId, ...additionalMembers];

    return ChallengeChatModel.fromJson(response, memberIds: allMemberIds);
  }

  /// Get a challenge by ID with its members, goals, and events.
  Future<ChallengeChatModel?> getById(String id) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    final memberIds = await getMemberIds(id);
    final goals = await _getGoals(id);
    final events = await _getEvents(id);

    return ChallengeChatModel.fromJson(
      response,
      memberIds: memberIds,
      goals: goals,
      events: events,
    );
  }

  /// Get all challenges for the current user.
  Future<List<ChallengeChatModel>> getForCurrentUser() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return [];

    // Get challenge IDs where user is a member
    final membershipResponse = await _client
        .from(_membersTable)
        .select('challenge_id')
        .eq('user_id', userId);

    final challengeIds = (membershipResponse as List)
        .map((m) => m['challenge_id'] as String)
        .toList();

    if (challengeIds.isEmpty) return [];

    // Get challenges
    final challengesResponse = await _client
        .from(_tableName)
        .select()
        .inFilter('id', challengeIds)
        .order('created_at', ascending: false);

    final challenges = <ChallengeChatModel>[];
    for (final json in challengesResponse) {
      final memberIds = await getMemberIds(json['id'] as String);
      final goals = await _getGoals(json['id'] as String);
      final events = await _getEvents(json['id'] as String);

      challenges.add(
        ChallengeChatModel.fromJson(
          json,
          memberIds: memberIds,
          goals: goals,
          events: events,
        ),
      );
    }

    return challenges;
  }

  /// Update a challenge.
  Future<ChallengeChatModel> update(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    final memberIds = await getMemberIds(id);
    final goals = await _getGoals(id);
    final events = await _getEvents(id);

    return ChallengeChatModel.fromJson(
      response,
      memberIds: memberIds,
      goals: goals,
      events: events,
    );
  }

  /// Delete a challenge.
  Future<void> delete(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }

  // =========================================================================
  // MEMBERS
  // =========================================================================

  /// Get member IDs for a challenge.
  Future<List<String>> getMemberIds(String challengeId) async {
    final response = await _client
        .from(_membersTable)
        .select('user_id')
        .eq('challenge_id', challengeId);

    return (response as List).map((m) => m['user_id'] as String).toList();
  }

  /// Add a member to a challenge.
  Future<void> addMember(
    String challengeId,
    String userId, {
    String role = 'member',
  }) async {
    await _client.from(_membersTable).insert({
      'challenge_id': challengeId,
      'user_id': userId,
      'role': role,
    });
  }

  /// Remove a member from a challenge.
  Future<void> removeMember(String challengeId, String userId) async {
    await _client
        .from(_membersTable)
        .delete()
        .eq('challenge_id', challengeId)
        .eq('user_id', userId);
  }

  // =========================================================================
  // HELPERS
  // =========================================================================

  Future<List<GoalModel>> _getGoals(String challengeId) async {
    final response = await _client
        .from('goals')
        .select()
        .eq('challenge_id', challengeId)
        .order('created_at', ascending: true);

    return (response as List).map((g) => GoalModel.fromJson(g)).toList();
  }

  Future<List<EventModel>> _getEvents(String challengeId) async {
    final response = await _client
        .from('challenge_events')
        .select()
        .eq('challenge_id', challengeId)
        .order('created_at', ascending: true);

    return (response as List).map((e) => EventModel.fromJson(e)).toList();
  }
}
