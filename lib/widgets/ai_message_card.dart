import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';

class AIMessageCard extends StatelessWidget {
  final EventModel event;

  const AIMessageCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: AppSizes.iconXLarge,
            height: AppSizes.iconXLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(
                alpha: AppOpacity.light,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.ai,
              size: AppSizes.iconSmall,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(width: AppSizes.spacing16),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacing14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(
                      alpha: AppOpacity.veryLight,
                    ),
                    blurRadius: AppSizes.blurMedium,
                    offset: AppSizes.shadowOffsetSmall,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      event.message!,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.white
                            : AppColors.darkSurface,
                        height: AppSizes.lineHeightRelaxed,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: AppTextStyles.smallSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacing48),
        ],
      ),
    );
  }
}
