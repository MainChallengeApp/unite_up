import 'package:dare_u/core/constants/app_constants.dart';
import 'package:dare_u/models/event_model.dart';
import 'package:flutter/material.dart';

class UserMessageCard extends StatelessWidget {
  final EventModel event;

  const UserMessageCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacing14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(4),
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
                style: const TextStyle(
                  fontSize: AppSizes.fontMedium,
                  color: Colors.white,
                  height: AppSizes.lineHeightRelaxed,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
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
