import 'package:flutter/material.dart';
import 'package:dare_u/core/constants/app_constants.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing24, vertical: AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppOpacity.veryLight),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.iconLarge,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontSmall,
              color: theme.iconTheme.color?.withValues(alpha: AppOpacity.mostlyOpaque),
            ),
          ),
        ],
      ),
    );
  }
}

