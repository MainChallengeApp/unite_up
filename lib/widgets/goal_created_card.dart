import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';

class GoalCreatedCard extends StatelessWidget {
  final EventModel event;

  const GoalCreatedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goal = event.goal!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: AppSizes.spacing48),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: AppOpacity.veryLight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMedium),
                  topRight: Radius.circular(AppSizes.radiusMedium),
                  bottomLeft: Radius.circular(AppSizes.radiusMedium),
                  bottomRight: Radius.circular(AppSizes.radiusTiny),
                ),
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
                              style: TextStyle(
                                fontSize: AppSizes.fontMedium,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy • HH:mm',
                              ).format(event.timestamp),
                              style: TextStyle(
                                fontSize: AppSizes.fontSmall,
                                color: theme.iconTheme.color?.withValues(
                                  alpha: AppOpacity.mostlyOpaque,
                                ),
                              ),
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
                        Text(
                          goal.title,
                          style: const TextStyle(
                            fontSize: AppSizes.fontLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                              style: TextStyle(
                                fontSize: AppSizes.fontMedium,
                                color: theme.iconTheme.color?.withValues(
                                  alpha: AppOpacity.mostlyOpaque,
                                ),
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
                              style: TextStyle(
                                fontSize: AppSizes.fontMedium,
                                color: theme.iconTheme.color?.withValues(
                                  alpha: AppOpacity.mostlyOpaque,
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
          ),
          const SizedBox(width: AppSizes.spacing16),
          Container(
            width: AppSizes.iconXLarge,
            height: AppSizes.iconXLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: AppOpacity.light,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.person,
              size: AppSizes.iconSmall,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
