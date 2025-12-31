import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      elevation: AppSizes.elevationLow,
      shadowColor: AppColors.black.withValues(alpha: AppOpacity.veryLight),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing24,
            vertical: AppSizes.spacing16,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: AppTextStyles.baseBold.copyWith(
                  fontSize: AppSizes.iconLarge,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                label,
                style: AppTextStyles.smallSecondary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

