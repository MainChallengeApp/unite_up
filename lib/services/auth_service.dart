import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/database/users_database.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/services/supabase_service.dart';

/// Authentication service using Supabase Auth.
class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  SupabaseClient get _client => SupabaseService.client;
  UsersDatabase get _userDb => UsersDatabase.instance;

  UserModel? _currentUser;

  /// Get the currently authenticated user profile.
  UserModel? get currentUser => _currentUser;

  /// Check if a user is currently authenticated.
  bool get isAuthenticated => _client.auth.currentUser != null;

  /// Get the current Supabase auth user ID.
  String? get currentUserId => _client.auth.currentUser?.id;

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Sign in with email and password.
  Future<UserModel> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed');
    }

    return _fetchAndCacheUserProfile(response.user!.id);
  }

  /// Sign up with email and password.
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );

    if (response.user == null) {
      throw Exception('Sign up failed');
    }

    return _fetchAndCacheUserProfile(response.user!.id);
  }

  /// Sign in with Google OAuth.
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _getRedirectUrl(),
    );
  }

  /// Sign in with Apple OAuth.
  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: _getRedirectUrl(),
    );
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
    _currentUser = null;
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Update user password.
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Fetch and cache the user profile from the database.
  Future<UserModel> _fetchAndCacheUserProfile(String userId) async {
    final user = await _userDb.getById(userId);
    if (user == null) {
      throw Exception('User profile not found');
    }
    _currentUser = user;
    return _currentUser!;
  }

  /// Load the current user profile if authenticated.
  /// Call this on app startup after auth state is restored.
  Future<UserModel?> loadCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return null;

    try {
      return await _fetchAndCacheUserProfile(userId);
    } catch (e) {
      // User might be authenticated but profile doesn't exist yet
      return null;
    }
  }

  /// Update the current user's profile.
  Future<UserModel> updateProfile({
    String? displayName,
    String? username,
    String? avatarUrl,
    String? bio,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (username != null) updates['username'] = username;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (bio != null) updates['bio'] = bio;

    if (updates.isEmpty) {
      return _currentUser!;
    }

    _currentUser = await _userDb.update(userId, updates);
    return _currentUser!;
  }

  /// Get redirect URL for OAuth based on platform.
  String? _getRedirectUrl() {
    // For web, return null (uses current URL)
    // For mobile, use deep link scheme
    // TODO: Configure deep links for mobile platforms
    return null;
  }
}
