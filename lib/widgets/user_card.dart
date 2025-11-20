import 'package:flutter/material.dart';

import 'package:dare_u/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onFollowToggle;

  const UserCard({
    super.key,
    required this.user,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _buildBoxDecoration(theme),
        child: Row(
          children: [
            _buildAvatar(theme),
            const SizedBox(width: 16),
            Expanded(child: _buildUserInfo(theme)),
            const SizedBox(width: 8),
            _buildFollowButton(theme),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: 28,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildName(theme),
        const SizedBox(height: 2),
        _buildUsername(theme),
        if (user.bio != null) ...[
          const SizedBox(height: 6),
          _buildBio(theme),
        ],
        const SizedBox(height: 8),
        _buildStats(theme),
      ],
    );
  }

  Widget _buildName(ThemeData theme) {
    return Text(
      user.name,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: theme.brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1E293B),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUsername(ThemeData theme) {
    return Text(
      user.username,
      style: TextStyle(
        fontSize: 13,
        color: theme.iconTheme.color?.withOpacity(0.6),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBio(ThemeData theme) {
    return Text(
      user.bio!,
      style: TextStyle(
        fontSize: 13,
        color: theme.iconTheme.color?.withOpacity(0.7),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _buildStat(
          '${user.completedChallengesCount}',
          'Challenges',
          theme,
        ),
        _buildStat('${user.followersCount}', 'Followers', theme),
      ],
    );
  }

  Widget _buildStat(String value, String label, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.iconTheme.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton(ThemeData theme) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onFollowToggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: user.isFollowing
                ? theme.cardColor
                : theme.colorScheme.primary,
            foregroundColor: user.isFollowing
                ? theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B)
                : Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: user.isFollowing
                  ? BorderSide(
                      color: theme.dividerColor.withOpacity(0.3),
                      width: 1,
                    )
                  : BorderSide.none,
            ),
          ),
          child: Text(
            user.isFollowing ? 'Following' : 'Follow',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

