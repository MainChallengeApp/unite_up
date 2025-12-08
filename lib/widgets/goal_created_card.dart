import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/widgets/event_card_wrapper.dart';

class GoalCreatedCard extends StatelessWidget {
  final EventModel event;

  const GoalCreatedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goal = event.goal!;

    return EventCardWrapper(
      event: event,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(
            alpha: AppOpacity.veryLight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(
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
                    color: theme.colorScheme.primary.withValues(
                      alpha: AppOpacity.light,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcons.flag,
                    size: AppSizes.iconSmall,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'goals.newGoalCreated'.tr(),
                        style: AppTextStyles.mediumSemiBold.copyWith(
                          color: theme.colorScheme.primary,
                        ),
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
                  const SizedBox(height: AppSizes.spacing8),
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: AppSizes.iconSmall,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.mostlyOpaque,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      Text(
                        '${goal.startValue.toStringAsFixed(goal.startValue.truncateToDouble() == goal.startValue ? 0 : 1)} ${goal.unit ?? ""} → ${goal.endValue.toStringAsFixed(goal.endValue.truncateToDouble() == goal.endValue ? 0 : 1)} ${goal.unit ?? ""}',
                        style: AppTextStyles.secondaryText(
                          context,
                          fontSize: AppSizes.fontMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: AppSizes.iconSmall,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.mostlyOpaque,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      Text(
                        '${DateFormat('MMM dd').format(goal.startDate)} - ${DateFormat('MMM dd, yyyy').format(goal.endDate)}',
                        style: AppTextStyles.secondaryText(
                          context,
                          fontSize: AppSizes.fontMedium,
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
