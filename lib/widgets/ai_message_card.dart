import 'package:flutter/material.dart';

import 'package:dare_u/models/event_model.dart';
import 'package:dare_u/core/constants/app_constants.dart';

class AIMessageCard extends StatelessWidget {
  final EventModel event;

  const AIMessageCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: AppSizes.iconXLarge,
            height: AppSizes.iconXLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: AppOpacity.light),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.ai,
              size: AppSizes.iconSmall,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
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
                    color: Colors.black.withValues(alpha: AppOpacity.veryLight),
                    blurRadius: AppSizes.blurMedium,
                    offset: AppSizes.shadowOffsetSmall,
                  ),
                ],
              ),
              child: Text(
                event.message!,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                  height: AppSizes.lineHeightRelaxed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
