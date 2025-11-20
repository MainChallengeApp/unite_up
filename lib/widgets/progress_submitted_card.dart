import 'package:flutter/material.dart';

import 'package:dare_u/models/event_model.dart';
import 'package:dare_u/core/constants/app_constants.dart';
import 'package:dare_u/widgets/app_card_container.dart';

class ProgressSubmittedCard extends StatelessWidget {
  final EventModel event;

  const ProgressSubmittedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = event.progressEntry!;

    return AppCardContainer(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing8),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upload_rounded,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: AppSizes.spacing8),
                Text(
                  'Progress Submitted',
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (progress.note.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spacing12),
              Text(
                progress.note,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
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
                      color: theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
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
                          style: TextStyle(
                            fontSize: AppSizes.fontSmall,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
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
    );
  }

  IconData _getMediaIcon(type) {
    switch (type.toString()) {
      case 'MediaType.image':
        return Icons.image_rounded;
      case 'MediaType.video':
        return Icons.videocam_rounded;
      default:
        return Icons.attach_file_rounded;
    }
  }
}

