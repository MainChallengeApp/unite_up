import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unite_up/services/env_service.dart';

/// Service class for Supabase initialization and access.
///
/// Provides a clean interface to the Supabase client with
/// secure configuration loading from environment variables.
class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  /// Initialize Supabase with configuration from environment variables.
  /// Must be called once before using any Supabase functionality.
  /// Requires [EnvService] to be initialized first.
  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: EnvService.supabaseUrl,
      anonKey: EnvService.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _initialized = true;
  }

  /// Get the Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Get the current authenticated user, or null if not authenticated.
  static User? get currentUser => client.auth.currentUser;

  /// Get the current session, or null if not authenticated.
  static Session? get currentSession => client.auth.currentSession;

  /// Check if a user is currently authenticated.
  static bool get isAuthenticated => currentUser != null;

  /// Stream of authentication state changes.
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
