class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? username;
  final String? avatarUrl;
  final String? bio;
  final String authProvider;
  final int followersCount;
  final int followingCount;
  final int completedChallengesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  // UI-only field (not stored in database)
  final bool isFollowing;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.username,
    this.avatarUrl,
    this.bio,
    required this.authProvider,
    this.followersCount = 0,
    this.followingCount = 0,
    this.completedChallengesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isFollowing = false,
  });

  /// Create UserModel from Supabase JSON response.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      authProvider: json['auth_provider'] as String? ?? 'email',
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      completedChallengesCount: json['completed_challenges_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert UserModel to JSON for Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
      'auth_provider': authProvider,
      'followers_count': followersCount,
      'following_count': followingCount,
      'completed_challenges_count': completedChallengesCount,
    };
  }

  /// Convert to JSON for profile updates (excludes read-only fields).
  Map<String, dynamic> toUpdateJson() {
    return {
      'display_name': displayName,
      'username': username,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }

  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? username,
    String? avatarUrl,
    String? bio,
    String? authProvider,
    int? followersCount,
    int? followingCount,
    int? completedChallengesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFollowing,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      authProvider: authProvider ?? this.authProvider,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      completedChallengesCount:
          completedChallengesCount ?? this.completedChallengesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
