import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/notification_item_model.dart';
import 'package:unite_up/widgets/app_card_container.dart';
import 'package:unite_up/widgets/custom_slidable_action_button.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onFollowBack;
  final bool isDeleting;
  final bool isFollowing;
  final bool isFollowLoading;

  const NotificationItemCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.onFollowBack,
    this.isDeleting = false,
    this.isFollowing = false,
    this.isFollowLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = notification.getIconColor(context);

    final cardContent = AppCardContainer(
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIconContainer(theme, iconColor),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(child: _buildContent(context, theme)),
                if (!notification.isRead) _buildUnreadIndicator(theme),
              ],
            ),
          ),
        ),
      ),
    );

    return AnimatedSlide(
      offset: isDeleting ? AppSizes.slideOffsetLeft : AppSizes.slideOffsetZero,
      duration: AppDurations.animationNormal,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isDeleting ? 0.0 : 1.0,
        duration: AppDurations.animationNormal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacing12),
          child: Slidable(
            key: Key(notification.id),
            closeOnScroll: true,
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: AppSizes.slidableExtentRatio,
              dragDismissible: false,
              dismissible: DismissiblePane(
                closeOnCancel: true,
                onDismissed: () {
                  HapticFeedback.mediumImpact();
                  onDismiss?.call();
                },
              ),
              children: [
                CustomSlidableAction(
                  onPressed: (_) {
                    HapticFeedback.lightImpact();
                    onDismiss?.call();
                  },
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spacing16,
                    0,
                    0,
                    0,
                  ),
                  child: const CustomSlidableActionButton(
                    icon: AppIcons.delete,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
            child: cardContent,
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme, Color iconColor) {
    return Container(
      width: AppSizes.containerSmall,
      height: AppSizes.containerSmall,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: AppOpacity.light),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Icon(
        notification.icon,
        color: iconColor,
        size: AppSizes.iconMedium,
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: AppTextStyles.mediumSemiBoldPrimary(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spacing4),
        Text(
          notification.body,
          style: AppTextStyles.regularSecondary(context),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spacing8),
        Row(
          children: [
            Text(
              _formatTimeAgo(notification.createdAt),
              style: AppTextStyles.smallSecondary(context),
            ),
            if (_showFollowBackButton) ...[
              const Spacer(),
              _buildFollowBackButton(context, theme),
            ],
          ],
        ),
      ],
    );
  }

  bool get _showFollowBackButton =>
      notification.type == NotificationType.follow &&
      notification.actionUserId != null &&
      onFollowBack != null;

  Widget _buildFollowBackButton(BuildContext context, ThemeData theme) {
    if (isFollowing) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing12,
          vertical: AppSizes.spacing4,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: AppSizes.borderThin,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: Text(
          'profile.following'.tr(),
          style: AppTextStyles.smallSecondary(context),
        ),
      );
    }

    return SizedBox(
      height: AppSizes.spacing24,
      child: FilledButton(
        onPressed: isFollowLoading ? null : onFollowBack,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isFollowLoading
            ? const SizedBox(
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.borderMedium,
                  color: AppColors.white,
                ),
              )
            : Text(
                'notifications.followBack'.tr(),
                style: const TextStyle(fontSize: AppSizes.fontSmall),
              ),
      ),
    );
  }

  Widget _buildUnreadIndicator(ThemeData theme) {
    return Container(
      width: AppSizes.spacing8,
      height: AppSizes.spacing8,
      margin: const EdgeInsets.only(top: AppSizes.spacing4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
