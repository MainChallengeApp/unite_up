class UserModel {
  final String id;
  final String username;
  final String? displayName;
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
    required this.username,
    this.displayName,
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
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
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
      'username': username,
      'display_name': displayName,
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
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }

  /// Returns the display name for UI, falling back to username if not set.
  String get name => displayName ?? username;

  String get initials {
    final displayText = name;
    final names = displayText.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayText.isNotEmpty ? displayText[0].toUpperCase() : '?';
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? displayName,
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
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
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
