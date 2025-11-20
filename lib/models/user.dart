class User {
  final String id;
  final String name;
  final String username;
  final String? avatarUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int completedChallengesCount;
  final bool isFollowing;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
    this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.completedChallengesCount,
    this.isFollowing = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? avatarUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? completedChallengesCount,
    bool? isFollowing,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      completedChallengesCount:
          completedChallengesCount ?? this.completedChallengesCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

