import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/widgets/app_card_container.dart';

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

    return AppCardContainer(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing24, vertical: AppSizes.spacing16),
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
    );
  }
}

