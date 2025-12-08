import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Database operations for the user_follows table.
class UserFollowsDatabase {
  UserFollowsDatabase._();

  static final UserFollowsDatabase _instance = UserFollowsDatabase._();
  static UserFollowsDatabase get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;

  static const String _tableName = 'user_follows';

  /// Follow a user.
  Future<void> follow(String followingId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) {
      throw Exception('Must be authenticated to follow');
    }

    await _client.from(_tableName).insert({
      'follower_id': currentUserId,
      'following_id': followingId,
    });
  }

  /// Unfollow a user.
  Future<void> unfollow(String followingId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) {
      throw Exception('Must be authenticated to unfollow');
    }

    await _client
        .from(_tableName)
        .delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', followingId);
  }

  /// Check if current user is following a specific user.
  Future<bool> isFollowing(String userId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return false;

    final response = await _client
        .from(_tableName)
        .select('id')
        .eq('follower_id', currentUserId)
        .eq('following_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Get list of users that a user is following.
  Future<List<UserModel>> getFollowing(String userId, {int limit = 50}) async {
    final response = await _client
        .from(_tableName)
        .select('following_id, users!user_follows_following_id_fkey(*)')
        .eq('follower_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List).map((row) {
      return UserModel.fromJson(row['users'] as Map<String, dynamic>);
    }).toList();
  }

  /// Get list of users that follow a user.
  Future<List<UserModel>> getFollowers(String userId, {int limit = 50}) async {
    final response = await _client
        .from(_tableName)
        .select('follower_id, users!user_follows_follower_id_fkey(*)')
        .eq('following_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List).map((row) {
      return UserModel.fromJson(row['users'] as Map<String, dynamic>);
    }).toList();
  }

  /// Get following IDs for a user (lightweight, just IDs).
  Future<List<String>> getFollowingIds(String userId) async {
    final response = await _client
        .from(_tableName)
        .select('following_id')
        .eq('follower_id', userId);

    return (response as List)
        .map((row) => row['following_id'] as String)
        .toList();
  }

  /// Get follower IDs for a user (lightweight, just IDs).
  Future<List<String>> getFollowerIds(String userId) async {
    final response = await _client
        .from(_tableName)
        .select('follower_id')
        .eq('following_id', userId);

    return (response as List)
        .map((row) => row['follower_id'] as String)
        .toList();
  }

  /// Check follow status for multiple users at once.
  /// Returns a map of userId -> isFollowing.
  Future<Map<String, bool>> getFollowStatusBatch(List<String> userIds) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) {
      return {for (var id in userIds) id: false};
    }

    final response = await _client
        .from(_tableName)
        .select('following_id')
        .eq('follower_id', currentUserId)
        .inFilter('following_id', userIds);

    final followingSet = (response as List)
        .map((row) => row['following_id'] as String)
        .toSet();

    return {for (var id in userIds) id: followingSet.contains(id)};
  }
}
