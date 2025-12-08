import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Database operations for the goals table.
class GoalsDatabase {
  GoalsDatabase._();

  static final GoalsDatabase _instance = GoalsDatabase._();
  static GoalsDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'goals';

  /// Create a new goal.
  Future<GoalModel> create(GoalModel goal) async {
    final response = await _client
        .from(_tableName)
        .insert(goal.toJson())
        .select()
        .single();

    return GoalModel.fromJson(response);
  }

  /// Get a goal by ID.
  Future<GoalModel?> getById(String id) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return GoalModel.fromJson(response);
  }

  /// Get all goals for a challenge.
  Future<List<GoalModel>> getForChallenge(String challengeId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('challenge_id', challengeId)
        .order('created_at', ascending: true);

    return (response as List).map((g) => GoalModel.fromJson(g)).toList();
  }

  /// Get all goals for a user in a challenge.
  Future<List<GoalModel>> getForUserInChallenge(
    String challengeId,
    String userId,
  ) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('challenge_id', challengeId)
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List).map((g) => GoalModel.fromJson(g)).toList();
  }

  /// Get all goals for a user across all challenges.
  Future<List<GoalModel>> getForUser(String userId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((g) => GoalModel.fromJson(g)).toList();
  }

  /// Update a goal.
  Future<GoalModel> update(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    return GoalModel.fromJson(response);
  }

  /// Update goal progress.
  Future<GoalModel> updateProgress(String id, double newValue) async {
    return update(id, {'current_value': newValue});
  }

  /// Delete a goal.
  Future<void> delete(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}
