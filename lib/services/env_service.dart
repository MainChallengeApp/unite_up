import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for accessing environment variables.
///
/// Must be initialized once at app startup before accessing any values.
class EnvService {
  EnvService._();

  static bool _initialized = false;

  /// Initialize the environment service by loading the .env file.
  /// Loads `.env.local` if it exists (for local development), otherwise `.env`.
  /// Must be called once before accessing any environment variables.
  static Future<void> initialize() async {
    if (_initialized) return;

    // Try .env.local first for local development
    final envFile = File('.env.local').existsSync() ? '.env.local' : '.env';
    await dotenv.load(fileName: envFile);
    _initialized = true;
  }

  /// Supabase project URL.
  static String get supabaseUrl => _getRequired('SUPABASE_URL');

  /// Supabase anonymous key for client-side access.
  static String get supabaseAnonKey => _getRequired('SUPABASE_ANON_KEY');

  /// Get a required environment variable.
  /// Throws an exception if the variable is not set or empty.
  static String _getRequired(String key) {
    _ensureInitialized();
    final value = dotenv.env[key] ?? String.fromEnvironment(key);
    if (value.isEmpty) {
      throw Exception('$key is not set in .env file');
    }
    return value;
  }

  /// Get an optional environment variable with a default value.
  static String getOptional(String key, {String defaultValue = ''}) {
    _ensureInitialized();
    return dotenv.env[key] ??
        String.fromEnvironment(key, defaultValue: defaultValue);
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw Exception(
        'EnvService not initialized. Call EnvService.initialize() first.',
      );
    }
  }
}
