import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/widgets/app_card_container.dart';
import 'package:unite_up/widgets/event_card_wrapper.dart';

class ProgressSubmittedCard extends StatelessWidget {
  final EventModel event;

  const ProgressSubmittedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = event.progressEntry!;

    return EventCardWrapper(
      event: event,
      child: AppCardContainer(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  AppIcons.upload,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: AppSizes.spacing8),
                Text(
                  'Progress Submitted',
                  style: AppTextStyles.smallSemiBold.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (progress.note.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spacing12),
              Text(
                progress.note,
                style: AppTextStyles.baseMedium.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.darkSurface,
                ),
              ),
            ],
            if (progress.attachments.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spacing12),
              Wrap(
                spacing: AppSizes.spacing8,
                runSpacing: AppSizes.spacing8,
                children: progress.attachments.map((attachment) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(
                        alpha: AppOpacity.light,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getMediaIcon(attachment.type),
                          size: AppSizes.spacing14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSizes.spacing6),
                        Text(
                          attachment.fileName ?? 'Attachment',
                          style: AppTextStyles.smallMedium.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getMediaIcon(type) {
    switch (type.toString()) {
      case 'MediaType.image':
        return AppIcons.image;
      case 'MediaType.video':
        return AppIcons.video;
      default:
        return AppIcons.attachFile;
    }
  }
}
