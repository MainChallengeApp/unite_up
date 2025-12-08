import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/widgets/event_card_wrapper.dart';

class GoalProgressUpdatedCard extends StatelessWidget {
  final EventModel event;

  const GoalProgressUpdatedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goal = event.goal!;

    return EventCardWrapper(
      event: event,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: goal.isCompleted
              ? AppColors.green.withValues(alpha: AppOpacity.veryLight)
              : theme.colorScheme.secondary.withValues(
                  alpha: AppOpacity.veryLight,
                ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: goal.isCompleted
                ? AppColors.green.withValues(alpha: AppOpacity.light)
                : theme.colorScheme.secondary.withValues(
                    alpha: AppOpacity.light,
                  ),
            width: AppSizes.borderThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing8),
                  decoration: BoxDecoration(
                    color: goal.isCompleted
                        ? AppColors.green.withValues(alpha: AppOpacity.light)
                        : theme.colorScheme.secondary.withValues(
                            alpha: AppOpacity.light,
                          ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    goal.isCompleted ? AppIcons.checkCircle : AppIcons.trophy,
                    size: AppSizes.iconSmall,
                    color: goal.isCompleted
                        ? AppColors.green
                        : theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.isCompleted
                            ? 'goals.goalCompleted'.tr()
                            : 'goals.progressUpdated'.tr(),
                        style: AppTextStyles.mediumSemiBold.copyWith(
                          color: goal.isCompleted
                              ? AppColors.green
                              : theme.colorScheme.secondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • HH:mm',
                        ).format(event.timestamp),
                        style: AppTextStyles.smallSecondary(context),
                      ),
                    ],
                  ),
                ),
                if (goal.isCompleted)
                  Text('🎉', style: AppTextStyles.baseXXLarge),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: AppTextStyles.largeSemiBold),
                  const SizedBox(height: AppSizes.spacing12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    child: LinearProgressIndicator(
                      value: goal.progressPercentage / 100,
                      minHeight: AppSizes.spacing10,
                      backgroundColor: theme.dividerColor.withValues(
                        alpha: AppOpacity.light,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goal.isCompleted
                            ? AppColors.green
                            : theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentValue.toStringAsFixed(goal.currentValue.truncateToDouble() == goal.currentValue ? 0 : 1)} ${goal.unit ?? ""} / ${goal.endValue.toStringAsFixed(goal.endValue.truncateToDouble() == goal.endValue ? 0 : 1)} ${goal.unit ?? ""}',
                        style: AppTextStyles.mediumWeight.copyWith(
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.mostlyOpaque,
                          ),
                        ),
                      ),
                      Text(
                        '${goal.progressPercentage.toStringAsFixed(0)}%',
                        style: AppTextStyles.xLargeBold.copyWith(
                          color: goal.isCompleted
                              ? AppColors.green
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
