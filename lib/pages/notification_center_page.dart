import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/notification_item_model.dart';
import 'package:unite_up/pages/chat_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/notifications_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/empty_state.dart';
import 'package:unite_up/widgets/notification_item_card.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  final Map<String, bool> _followingStatus = {};
  final Set<String> _loadingFollowIds = {};

  @override
  void initState() {
    super.initState();
    _loadFollowingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        return Scaffold(
          appBar: _buildAppBar(notificationsProvider),
          body: _buildBody(notificationsProvider),
        );
      },
    );
  }

  Future<void> _loadFollowingStatus() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    final usersProvider = context.read<UsersProvider>();

    // Get all action user IDs from follow notifications
    final followNotifications = notificationsProvider.notifications
        .where((n) =>
            n.type == NotificationType.follow && n.actionUserId != null)
        .toList();

    if (followNotifications.isEmpty) return;

    final userIds = followNotifications
        .map((n) => n.actionUserId!)
        .toSet()
        .toList();

    // Batch fetch follow status
    final statusMap = await usersProvider.getFollowStatusBatch(userIds);

    if (mounted) {
      setState(() {
        _followingStatus.addAll(statusMap);
      });
    }
  }

  Future<void> _onFollowBack(String userId) async {
    final usersProvider = context.read<UsersProvider>();

    setState(() {
      _loadingFollowIds.add(userId);
    });

    try {
      await usersProvider.follow(userId);
      if (mounted) {
        setState(() {
          _followingStatus[userId] = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingFollowIds.remove(userId);
        });
      }
    }
  }

  void _onNotificationTap(
    NotificationsProvider provider,
    NotificationItemModel notification,
  ) {
    provider.markAsRead(notification.id);

    switch (notification.type) {
      case NotificationType.challengeInvite:
        _handleChallengeInviteTap(notification);
        break;
      case NotificationType.follow:
      case NotificationType.goalCompleted:
      case NotificationType.progressUpdate:
      case NotificationType.system:
        // No navigation for these types yet
        break;
    }
  }

  void _handleChallengeInviteTap(NotificationItemModel notification) {
    if (notification.challengeId == null) return;

    final appState = context.read<AppStateProvider>();
    final challenges = appState.challenges;

    // Check if user is still a member of this challenge
    final isStillMember = challenges.any((c) => c.id == notification.challengeId);

    if (isStillMember) {
      // Select the challenge and navigate to chat
      appState.selectChallenge(notification.challengeId!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage()),
      );
    } else {
      // Show message that user is no longer a member
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('notifications.challengeNoLongerMember'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(NotificationsProvider provider) {
    return CustomAppBar(
      title: 'notifications.title'.tr(),
      actions: provider.hasUnread
          ? [
              IconButton(
                icon: const Icon(AppIcons.checkCircleOutline),
                onPressed: provider.markAllAsRead,
                tooltip: 'notifications.markAllRead'.tr(),
              ),
              const SizedBox(width: AppSizes.spacing8),
            ]
          : null,
    );
  }

  Widget _buildBody(NotificationsProvider provider) {
    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.notifications.isEmpty) {
      return _buildEmptyState();
    }

    return _buildNotificationList(provider);
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: AppIcons.notifications,
      title: 'notifications.empty.title'.tr(),
      subtitle: 'notifications.empty.subtitle'.tr(),
    );
  }

  Widget _buildNotificationList(NotificationsProvider provider) {
    return RefreshIndicator(
      onRefresh: () async {
        await provider.reload();
        await _loadFollowingStatus();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        itemCount: provider.notifications.length,
        itemBuilder: (context, index) {
          final notification = provider.notifications[index];
          final isDeleting = provider.deletingIds.contains(notification.id);
          final isFollowing =
              _followingStatus[notification.actionUserId] ?? false;
          final isFollowLoading =
              _loadingFollowIds.contains(notification.actionUserId);

          return NotificationItemCard(
            notification: notification,
            isDeleting: isDeleting,
            isFollowing: isFollowing,
            isFollowLoading: isFollowLoading,
            onTap: () => _onNotificationTap(provider, notification),
            onDismiss: () => provider.delete(notification.id),
            onFollowBack: notification.actionUserId != null
                ? () => _onFollowBack(notification.actionUserId!)
                : null,
          );
        },
      ),
    );
  }
}
