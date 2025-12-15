import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Database operations for the users table.
class UsersDatabase {
  UsersDatabase._();

  static final UsersDatabase _instance = UsersDatabase._();
  static UsersDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'users';

  /// Fetch a user by ID.
  Future<UserModel?> getById(String id) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  /// Search users by display name or username.
  Future<List<UserModel>> search(String query, {int limit = 20}) async {
    final response = await _client
        .from(_tableName)
        .select()
        .or('display_name.ilike.%$query%,username.ilike.%$query%')
        .limit(limit);

    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }

  /// Update a user's profile.
  Future<UserModel> update(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  /// Update display name.
  Future<UserModel> updateDisplayName(String id, String displayName) async {
    return update(id, {'display_name': displayName});
  }

  /// Update username.
  Future<UserModel> updateUsername(String id, String username) async {
    return update(id, {'username': username});
  }

  /// Update avatar URL.
  Future<UserModel> updateAvatarUrl(String id, String? avatarUrl) async {
    return update(id, {'avatar_url': avatarUrl});
  }

  /// Update bio.
  Future<UserModel> updateBio(String id, String? bio) async {
    return update(id, {'bio': bio});
  }

  /// Check if a username is available.
  Future<bool> isUsernameAvailable(String username) async {
    final response = await _client
        .from(_tableName)
        .select('id')
        .eq('username', username)
        .maybeSingle();

    return response == null;
  }

  /// Increment followers count.
  Future<void> incrementFollowersCount(String id) async {
    await _client.rpc('increment_followers_count', params: {'user_id': id});
  }

  /// Decrement followers count.
  Future<void> decrementFollowersCount(String id) async {
    await _client.rpc('decrement_followers_count', params: {'user_id': id});
  }

  /// Increment following count.
  Future<void> incrementFollowingCount(String id) async {
    await _client.rpc('increment_following_count', params: {'user_id': id});
  }

  /// Decrement following count.
  Future<void> decrementFollowingCount(String id) async {
    await _client.rpc('decrement_following_count', params: {'user_id': id});
  }

  /// Increment completed challenges count.
  Future<void> incrementCompletedChallengesCount(String id) async {
    await _client.rpc(
      'increment_completed_challenges_count',
      params: {'user_id': id},
    );
  }

  /// Delete a user by ID.
  Future<void> deleteById(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}
