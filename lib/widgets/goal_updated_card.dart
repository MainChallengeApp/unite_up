import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';

class GoalUpdatedCard extends StatelessWidget {
  final EventModel event;

  const GoalUpdatedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newGoal = event.goal!;
    final oldGoal = event.oldGoal!;
    final completedByUpdate = event.goalCompletedByUpdate ?? false;
    final cardColor = completedByUpdate ? AppColors.green : AppColors.blue;

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
                color: cardColor.withValues(alpha: AppOpacity.veryLight),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMedium),
                  topRight: Radius.circular(AppSizes.radiusMedium),
                  bottomLeft: Radius.circular(AppSizes.radiusMedium),
                  bottomRight: Radius.circular(AppSizes.radiusTiny),
                ),
                border: Border.all(
                  color: cardColor.withValues(alpha: AppOpacity.light),
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
                          color: cardColor.withValues(alpha: AppOpacity.light),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          completedByUpdate
                              ? AppIcons.checkCircle
                              : AppIcons.edit,
                          size: AppSizes.iconSmall,
                          color: cardColor,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              completedByUpdate
                                  ? 'goals.goalCompleted'.tr()
                                  : 'goals.goalUpdated'.tr(),
                              style: AppTextStyles.mediumSemiBold.copyWith(
                                color: cardColor,
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
                      if (completedByUpdate)
                        Text('🎉', style: AppTextStyles.baseXXLarge),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  // Show completion celebration
                  if (completedByUpdate) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spacing12),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.3),
                          width: AppSizes.borderThin,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            AppIcons.trophy,
                            color: AppColors.green,
                            size: AppSizes.iconLarge,
                          ),
                          const SizedBox(width: AppSizes.spacing12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'goals.achievedByLoweringTarget'.tr(),
                                  style: AppTextStyles.mediumSemiBold.copyWith(
                                    color: AppColors.green,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.spacing4),
                                Text(
                                  'goals.goalCompletedDescription'.tr(),
                                  style: AppTextStyles.smallSecondary(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                  ],
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spacing12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Always show goal name at the top
                        Text(newGoal.title, style: AppTextStyles.largeSemiBold),
                        if (oldGoal.title != newGoal.title ||
                            oldGoal.endValue != newGoal.endValue ||
                            oldGoal.startValue != newGoal.startValue ||
                            oldGoal.unit != newGoal.unit ||
                            oldGoal.endDate != newGoal.endDate)
                          const SizedBox(height: AppSizes.spacing16),

                        // Title changes
                        if (oldGoal.title != newGoal.title) ...[
                          _buildChangeRow(
                            context,
                            theme,
                            icon: AppIcons.flag,
                            label: 'goals.goalTitle'.tr(),
                            oldValue: oldGoal.title,
                            newValue: newGoal.title,
                          ),
                          const SizedBox(height: AppSizes.spacing12),
                        ],

                        // Target value changes
                        if (oldGoal.endValue != newGoal.endValue) ...[
                          _buildChangeRow(
                            context,
                            theme,
                            icon: AppIcons.flag,
                            label: 'goals.target'.tr(),
                            oldValue:
                                '${_formatValue(oldGoal.endValue)} ${oldGoal.unit ?? ""}',
                            newValue:
                                '${_formatValue(newGoal.endValue)} ${newGoal.unit ?? ""}',
                          ),
                          const SizedBox(height: AppSizes.spacing12),
                        ],

                        // Start value changes
                        if (oldGoal.startValue != newGoal.startValue) ...[
                          _buildChangeRow(
                            context,
                            theme,
                            icon: Icons.track_changes,
                            label: 'goals.startValue'.tr(),
                            oldValue:
                                '${_formatValue(oldGoal.startValue)} ${oldGoal.unit ?? ""}',
                            newValue:
                                '${_formatValue(newGoal.startValue)} ${newGoal.unit ?? ""}',
                          ),
                          const SizedBox(height: AppSizes.spacing12),
                        ],

                        // Unit changes
                        if (oldGoal.unit != newGoal.unit) ...[
                          _buildChangeRow(
                            context,
                            theme,
                            icon: Icons.straighten_rounded,
                            label: 'goals.unit'.tr(),
                            oldValue: oldGoal.unit ?? 'goals.noUnit'.tr(),
                            newValue: newGoal.unit ?? 'goals.noUnit'.tr(),
                          ),
                          const SizedBox(height: AppSizes.spacing12),
                        ],

                        // Date changes
                        if (oldGoal.endDate != newGoal.endDate) ...[
                          _buildChangeRow(
                            context,
                            theme,
                            icon: Icons.calendar_today,
                            label: 'goals.endDate'.tr(),
                            oldValue: DateFormat(
                              'MMM dd, yyyy',
                            ).format(oldGoal.endDate),
                            newValue: DateFormat(
                              'MMM dd, yyyy',
                            ).format(newGoal.endDate),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeRow(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String oldValue,
    required String newValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconSmall,
              color: theme.iconTheme.color?.withValues(
                alpha: AppOpacity.mostlyOpaque,
              ),
            ),
            const SizedBox(width: AppSizes.spacing8),
            Text(
              label,
              style: AppTextStyles.smallSemiBold.copyWith(
                color: theme.iconTheme.color?.withValues(
                  alpha: AppOpacity.mostlyOpaque,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacing8),
        Container(
          padding: const EdgeInsets.all(AppSizes.spacing8),
          decoration: BoxDecoration(
            color: AppColors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusTiny),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.remove_circle_outline,
                size: AppSizes.iconSmall,
                color: AppColors.red,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Expanded(
                child: Text(
                  oldValue,
                  style: AppTextStyles.regularSecondary(
                    context,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacing4),
        Container(
          padding: const EdgeInsets.all(AppSizes.spacing8),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusTiny),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: AppSizes.iconSmall,
                color: AppColors.green,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Expanded(
                child: Text(
                  newValue,
                  style: AppTextStyles.mediumWeight.copyWith(
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}
