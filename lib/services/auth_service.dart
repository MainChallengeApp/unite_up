import 'package:dare_u/enums/auth_provider_enum.dart';
import 'package:dare_u/models/authenticated_user_model.dart';

class AuthService {
  AuthenticatedUserModel? _currentUser;

  AuthenticatedUserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Mock Google Sign In
  Future<AuthenticatedUserModel> signInWithGoogle() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = AuthenticatedUserModel(
      id: 'google_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@gmail.com',
      displayName: 'John Doe',
      photoUrl: null,
      provider: AuthProviderEnum.google,
      createdAt: DateTime.now(),
    );

    return _currentUser!;
  }

  // Mock Apple Sign In
  Future<AuthenticatedUserModel> signInWithApple() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = AuthenticatedUserModel(
      id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
      email: 'user@privaterelay.appleid.com',
      displayName: 'Jane Smith',
      photoUrl: null,
      provider: AuthProviderEnum.apple,
      createdAt: DateTime.now(),
    );

    return _currentUser!;
  }

  // Mock Email Sign In
  Future<AuthenticatedUserModel> signInWithEmail(
      String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    _currentUser = AuthenticatedUserModel(
      id: 'email_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@')[0],
      photoUrl: null,
      provider: AuthProviderEnum.email,
      createdAt: DateTime.now(),
    );

    return _currentUser!;
  }

  // Mock Email Sign Up
  Future<AuthenticatedUserModel> signUpWithEmail(
      String email, String password, String name) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    _currentUser = AuthenticatedUserModel(
      id: 'email_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name,
      photoUrl: null,
      provider: AuthProviderEnum.email,
      createdAt: DateTime.now(),
    );

    return _currentUser!;
  }

  // Sign Out
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }
}

