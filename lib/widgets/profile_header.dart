import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? displayName;

  const ProfileHeader({
    super.key,
    required this.username,
    this.displayName,
  });

  bool get _hasDisplayName =>
      displayName != null && displayName!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: AppSizes.spacing20),
        _buildAvatar(theme),
        const SizedBox(height: AppSizes.spacing20),
        _buildPrimaryText(theme),
        if (_hasDisplayName) ...[
          const SizedBox(height: AppSizes.spacing4),
          _buildSecondaryText(theme),
        ],
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: AppSizes.size100,
      height: AppSizes.size100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: AppOpacity.medium),
            theme.colorScheme.secondary.withValues(alpha: AppOpacity.medium),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        AppIcons.person,
        size: AppSizes.size50,
        color: theme.colorScheme.primary,
      ),
    );
  }

  /// Shows display_name in big font when set, otherwise username.
  Widget _buildPrimaryText(ThemeData theme) {
    final primaryText = _hasDisplayName ? displayName! : username;

    return Text(
      primaryText,
      style: AppTextStyles.baseBold.copyWith(
        fontSize: AppSizes.iconLarge,
        color: theme.brightness == Brightness.dark
            ? AppColors.white
            : AppColors.darkSurface,
      ),
    );
  }

  /// Shows username in smaller font when display_name is set.
  Widget _buildSecondaryText(ThemeData theme) {
    return Text(
      '@$username',
      style: AppTextStyles.baseMedium.copyWith(
        color: theme.iconTheme.color?.withValues(
          alpha: AppOpacity.mostlyOpaque,
        ),
      ),
    );
  }
}
