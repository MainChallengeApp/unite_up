import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_bottom_sheet.dart';

class UserMessageCard extends StatelessWidget {
  final EventModel event;

  const UserMessageCard({super.key, required this.event});

  void _showMessageOptions(BuildContext context, ThemeData theme) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomBottomSheet(
        options: [
          BottomSheetOption(
            icon: AppIcons.edit,
            label: 'common.edit'.tr(),
            color: theme.colorScheme.primary,
            onTap: () {
              Navigator.pop(context);
              _showEditDialog(context);
            },
          ),
          BottomSheetOption(
            icon: AppIcons.close,
            label: 'common.delete'.tr(),
            color: AppColors.red,
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: event.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('chat.editMessage'.tr()),
        content: TextField(
          controller: controller,
          maxLines: null,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'chat.enterMessage'.tr(),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<AppStateProvider>(
                  context,
                  listen: false,
                ).editMessage(event.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('chat.deleteMessage'.tr()),
        content: Text('chat.deleteMessageConfirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<AppStateProvider>(
                context,
                listen: false,
              ).deleteMessage(event.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

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
          const SizedBox(width: AppSizes.spacing48),
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(context, theme),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacing14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusLarge),
                    topRight: Radius.circular(AppSizes.radiusLarge),
                    bottomLeft: Radius.circular(AppSizes.radiusLarge),
                    bottomRight: Radius.circular(AppSizes.radiusTiny),
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
                        style: const TextStyle(
                          fontSize: AppSizes.fontMedium,
                          color: AppColors.white,
                          height: AppSizes.lineHeightRelaxed,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing8),
                    Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: TextStyle(
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.white.withValues(
                          alpha: AppOpacity.mostlyOpaque,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
