import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/widgets/event_card_wrapper.dart';

class GoalDeletedCard extends StatelessWidget {
  final EventModel event;

  const GoalDeletedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goal = event.goal!;

    return EventCardWrapper(
      event: event,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? theme.cardColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: AppOpacity.veryLight),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: AppOpacity.medium),
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
                    color: AppColors.red.withValues(alpha: AppOpacity.light),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.delete,
                    size: AppSizes.iconSmall,
                    color: AppColors.red,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'goals.goalDeleted'.tr(),
                        style: AppTextStyles.mediumSemiBold.copyWith(
                          color: theme.brightness == Brightness.dark
                              ? theme.iconTheme.color?.withValues(
                                  alpha: AppOpacity.mostlyOpaque,
                                )
                              : Colors.grey.shade700,
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
                color: theme.brightness == Brightness.dark
                    ? theme.cardColor.withValues(alpha: 0.5)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          goal.title,
                          style: AppTextStyles.largeSemiBold.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: theme.iconTheme.color?.withValues(
                              alpha: AppOpacity.semiTransparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: AppSizes.iconSmall,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.semiTransparent,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      Expanded(
                        child: Text(
                          '${_formatValue(goal.startValue)} ${goal.unit ?? ""} → ${_formatValue(goal.endValue)} ${goal.unit ?? ""}',
                          style: AppTextStyles.secondaryText(
                            context,
                            fontSize: AppSizes.fontMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  // Show progress at deletion
                  Row(
                    children: [
                      Icon(
                        AppIcons.stats,
                        size: AppSizes.iconSmall,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.semiTransparent,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      Expanded(
                        child: Text(
                          'goals.progressAtDeletion'.tr(
                            namedArgs: {
                              'progress': goal.progressPercentage
                                  .toStringAsFixed(0),
                              'current': _formatValue(goal.currentValue),
                              'unit': goal.unit == null || goal.unit == ''
                                  ? ''
                                  : ' ${goal.unit}',
                            },
                          ),
                          style: AppTextStyles.secondaryText(
                            context,
                            fontSize: AppSizes.fontMedium,
                          ),
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

  String _formatValue(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}
