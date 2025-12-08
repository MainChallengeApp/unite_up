import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_bottom_sheet.dart';

class UserMessageCard extends StatelessWidget {
  final EventModel event;

  const UserMessageCard({super.key, required this.event});

  bool _isFromCurrentUser(BuildContext context) {
    final currentUserId = Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).currentUser?.id;
    return event.userId == currentUserId;
  }

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
    final isFromCurrentUser = _isFromCurrentUser(context);

    if (isFromCurrentUser) {
      return _buildCurrentUserMessage(context);
    } else {
      return _buildOtherUserMessage(context);
    }
  }

  /// Message from the current user - displayed on the right
  Widget _buildCurrentUserMessage(BuildContext context) {
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
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.white,
                          height: AppSizes.lineHeightRelaxed,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing8),
                    Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: AppTextStyles.baseSmall.copyWith(
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

  /// Message from another user - displayed on the left with avatar
  Widget _buildOtherUserMessage(BuildContext context) {
    final theme = Theme.of(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return FutureBuilder(
      future: event.userId != null
          ? usersProvider.getUserById(event.userId!)
          : Future.value(null),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final userInitial = user?.displayName.isNotEmpty == true
            ? user!.displayName[0].toUpperCase()
            : '?';

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar
              Container(
                width: AppSizes.iconXLarge,
                height: AppSizes.iconXLarge,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(
                    alpha: AppOpacity.light,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userInitial,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              // Message bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spacing14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusLarge),
                      topRight: Radius.circular(AppSizes.radiusLarge),
                      bottomRight: Radius.circular(AppSizes.radiusLarge),
                      bottomLeft: Radius.circular(AppSizes.radiusTiny),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User name
                      if (user != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.spacing4,
                          ),
                          child: Text(
                            user.displayName,
                            style: AppTextStyles.smallMedium.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      // Message content
                      Row(
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
                          Text(
                            DateFormat('HH:mm').format(event.timestamp),
                            style: AppTextStyles.smallSecondary(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing48),
            ],
          ),
        );
      },
    );
  }
}
