import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/widgets/app_card_container.dart';

class UserModelCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFollowToggle;

  const UserModelCard({
    super.key,
    required this.user,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCardContainer(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing16),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Row(
        children: [
          _buildAvatar(theme),
          const SizedBox(width: AppSizes.spacing16),
          Expanded(child: _buildUserModelInfo(theme)),
          const SizedBox(width: AppSizes.spacing8),
          _buildFollowButton(theme),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: AppSizes.containerMedium,
      height: AppSizes.containerMedium,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
        shape: BoxShape.circle,
      ),
      child: Icon(
        AppIcons.person,
        size: AppSizes.emojiLarge,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildUserModelInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildName(theme),
        const SizedBox(height: AppSizes.spacing2),
        _buildUserModelname(theme),
        if (user.bio != null) ...[
          const SizedBox(height: AppSizes.spacing6),
          _buildBio(theme),
        ],
        const SizedBox(height: AppSizes.spacing8),
        _buildStats(theme),
      ],
    );
  }

  Widget _buildName(ThemeData theme) {
    return Text(
      user.name,
      style: TextStyle(
        fontSize: AppSizes.fontLarge,
        fontWeight: FontWeight.w600,
        color: theme.brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1E293B),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserModelname(ThemeData theme) {
    return Text(
      user.username,
      style: TextStyle(
        fontSize: AppSizes.fontRegular,
        color: theme.iconTheme.color?.withValues(
          alpha: AppOpacity.mostlyOpaque,
        ),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBio(ThemeData theme) {
    return Text(
      user.bio!,
      style: TextStyle(
        fontSize: AppSizes.fontRegular,
        color: theme.iconTheme.color?.withValues(
          alpha: AppOpacity.almostOpaque,
        ),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStats(ThemeData theme) {
    return Wrap(
      spacing: AppSizes.spacing12,
      runSpacing: AppSizes.spacing4,
      children: [
        _buildStat('${user.completedChallengesCount}', 'Challenges', theme),
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
            fontSize: AppSizes.fontMedium,
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: AppSizes.spacing4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontSmall,
            color: theme.iconTheme.color?.withValues(
              alpha: AppOpacity.mostlyOpaque,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowButton(ThemeData theme) {
    return ElevatedButton(
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
        elevation: AppSizes.elevationNone,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          side: user.isFollowing
              ? BorderSide(
                  color: theme.dividerColor.withValues(
                    alpha: AppOpacity.medium,
                  ),
                  width: AppSizes.borderThin,
                )
              : BorderSide.none,
        ),
      ),
      child: Text(
        user.isFollowing ? 'profile.following'.tr() : 'profile.follow'.tr(),
        style: const TextStyle(
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
