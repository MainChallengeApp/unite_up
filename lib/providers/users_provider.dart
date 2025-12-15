import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/database/user_follows_database.dart';
import 'package:unite_up/database/users_database.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Provider for managing user state and authentication.
class UsersProvider extends ChangeNotifier {
  UsersProvider() {
    _init();
  }

  final _usersDb = UsersDatabase.instance;
  final _userFollowsDb = UserFollowsDatabase.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<AuthState>? _authSubscription;

  // Cache for fetched user profiles
  final Map<String, UserModel> _userCache = {};

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserId => SupabaseService.client.auth.currentUser?.id;

  void _init() {
    _authSubscription = SupabaseService.authStateChanges.listen(
      _onAuthStateChanged,
    );
    // Try to load user if already authenticated
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Handle auth state changes (sign in, sign out, token refresh).
  Future<void> _onAuthStateChanged(AuthState state) async {
    switch (state.event) {
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.userUpdated:
        await _loadCurrentUser();
        break;
      case AuthChangeEvent.signedOut:
        _currentUser = null;
        _userCache.clear();
        notifyListeners();
        break;
      default:
        break;
    }
  }

  /// Load the current user's profile from the database.
  Future<void> _loadCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _usersDb.getById(userId);
      if (_currentUser != null) {
        _userCache[userId] = _currentUser!;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // Authentication
  // ============================================================================

  /// Sign in with email and password.
  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Auth state listener will handle loading the user
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Sign up with email and password.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );
      // Auth state listener will handle loading the user
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Sign in with Google OAuth.
  Future<void> signInWithGoogle() async {
    await SupabaseService.client.auth.signInWithOAuth(OAuthProvider.google);
  }

  /// Sign in with Apple OAuth.
  Future<void> signInWithApple() async {
    await SupabaseService.client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    _currentUser = null;
    _userCache.clear();
    notifyListeners();
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await SupabaseService.client.auth.resetPasswordForEmail(email);
  }

  // ============================================================================
  // Profile Management
  // ============================================================================

  /// Update the current user's profile.
  Future<void> updateProfile({
    String? displayName,
    String? username,
    String? avatarUrl,
    String? bio,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;

      if (updates.isNotEmpty) {
        _currentUser = await _usersDb.update(_currentUser!.id, updates);
        _userCache[_currentUser!.id] = _currentUser!;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if a username is available.
  Future<bool> isUsernameAvailable(String username) async {
    return _usersDb.isUsernameAvailable(username);
  }

  // ============================================================================
  // User Fetching
  // ============================================================================

  /// Get a user by ID (uses cache if available).
  Future<UserModel?> getUserById(String id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _userCache.containsKey(id)) {
      return _userCache[id];
    }

    final user = await _usersDb.getById(id);
    if (user != null) {
      _userCache[id] = user;
    }
    return user;
  }

  /// Search users by name or username.
  Future<List<UserModel>> searchUsers(String query, {int limit = 20}) async {
    final users = await _usersDb.search(query, limit: limit);
    // Cache the results
    for (final user in users) {
      _userCache[user.id] = user;
    }
    return users;
  }

  // ============================================================================
  // Follow Management
  // ============================================================================

  /// Follow a user.
  Future<void> follow(String userId) async {
    await _userFollowsDb.follow(userId);
    // Refresh both users to update counts
    await _loadCurrentUser();
    await getUserById(userId, forceRefresh: true);
    notifyListeners();
  }

  /// Unfollow a user.
  Future<void> unfollow(String userId) async {
    await _userFollowsDb.unfollow(userId);
    // Refresh both users to update counts
    await _loadCurrentUser();
    await getUserById(userId, forceRefresh: true);
    notifyListeners();
  }

  /// Check if current user is following a specific user.
  Future<bool> isFollowing(String userId) async {
    return _userFollowsDb.isFollowing(userId);
  }

  /// Get list of users that the current user is following.
  Future<List<UserModel>> getFollowing({int limit = 50}) async {
    if (_currentUser == null) return [];
    return _userFollowsDb.getFollowing(_currentUser!.id, limit: limit);
  }

  /// Get list of users that follow the current user.
  Future<List<UserModel>> getFollowers({int limit = 50}) async {
    if (_currentUser == null) return [];
    return _userFollowsDb.getFollowers(_currentUser!.id, limit: limit);
  }

  /// Clear the user cache.
  void clearCache() {
    _userCache.clear();
  }

  // delete the current user's account
  Future<void> deleteAccount() async {
    await _usersDb.deleteById(currentUserId!);
    await SupabaseService.deleteUser();
    _currentUser = null;
    _userCache.clear();
    notifyListeners();
  }
}
