import 'package:unite_up/enums/auth_provider_enum.dart';

class AuthenticatedUserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final AuthProviderEnum provider;
  final DateTime createdAt;

  AuthenticatedUserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.provider,
    required this.createdAt,
  });

  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }
}

