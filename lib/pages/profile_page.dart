import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/pages/auth_page.dart';
import 'package:unite_up/pages/home_page.dart';
import 'package:unite_up/pages/notification_center_page.dart';
import 'package:unite_up/pages/settings_page.dart';
import 'package:unite_up/pages/user_list_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/notifications_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/profile_header.dart';
import 'package:unite_up/widgets/profile_stat_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: _buildAppBar(appState.isAuthenticated),
            body: appState.isAuthenticated
                ? _buildProfileView(appState)
                : _buildAuthView(),
          ),
        );
      },
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationCenterPage()),
    );
  }

  void _navigateToChallenges() {
    HomePage.globalKey.currentState?.navigateToTab(1);
  }

  void _navigateToFollowers(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserListPage(userId: userId, listType: UserListType.followers),
      ),
    );
  }

  void _navigateToFollowing(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserListPage(userId: userId, listType: UserListType.following),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isAuthenticated) {
    return CustomAppBar(
      title: 'profile.title'.tr(),
      showBackButton: false,
      actions: isAuthenticated
          ? [
              _buildNotificationButton(),
              IconButton(
                icon: const Icon(AppIcons.settings),
                onPressed: _navigateToSettings,
                tooltip: 'settings.title'.tr(),
              ),
              const SizedBox(width: AppSizes.spacing8),
            ]
          : null,
    );
  }

  Widget _buildNotificationButton() {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        final unreadCount = notificationsProvider.unreadCount;

        return IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(
              unreadCount > 99 ? '99+' : unreadCount.toString(),
              style: const TextStyle(fontSize: AppSizes.fontSmall),
            ),
            child: const Icon(AppIcons.notifications),
          ),
          onPressed: _navigateToNotifications,
          tooltip: 'notifications.title'.tr(),
        );
      },
    );
  }

  Widget _buildAuthView() {
    return const AuthPage();
  }

  Widget _buildProfileView(AppStateProvider appState) {
    final user = appState.currentUser!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: () => _onRefresh(appState),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Column(
                  children: [
                    ProfileHeader(
                      username: user.username,
                      displayName: user.displayName,
                    ),
                    const SizedBox(height: AppSizes.spacing32),
                    _buildStatsRow(appState),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(AppStateProvider appState) async {
    await appState.reloadProfile();
  }

  Widget _buildStatsRow(AppStateProvider appState) {
    final user = appState.currentUser!;

    final challengesCount = appState.challenges.length;
    final followersCount = user.followersCount;
    final followingCount = user.followingCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatCard(
          value: challengesCount.toString(),
          label: 'profile.stats.challenges'.tr(),
          onTap: _navigateToChallenges,
        ),
        ProfileStatCard(
          value: followersCount.toString(),
          label: 'profile.stats.followers'.tr(),
          onTap: () => _navigateToFollowers(user.id),
        ),
        ProfileStatCard(
          value: followingCount.toString(),
          label: 'profile.stats.following'.tr(),
          onTap: () => _navigateToFollowing(user.id),
        ),
      ],
    );
  }
}
