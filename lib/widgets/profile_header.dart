import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: AppSizes.spacing20),
        _buildAvatar(theme),
        const SizedBox(height: AppSizes.spacing20),
        _buildName(theme),
        const SizedBox(height: AppSizes.spacing4),
        _buildEmail(theme),
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

  Widget _buildName(ThemeData theme) {
    return Text(
      name,
      style: TextStyle(
        fontSize: AppSizes.iconLarge,
        fontWeight: FontWeight.bold,
        color: theme.brightness == Brightness.dark
            ? AppColors.white
            : AppColors.darkSurface,
      ),
    );
  }

  Widget _buildEmail(ThemeData theme) {
    return Text(
      email,
      style: TextStyle(
        fontSize: AppSizes.fontMedium,
        color: theme.iconTheme.color?.withValues(
          alpha: AppOpacity.mostlyOpaque,
        ),
      ),
    );
  }
}
