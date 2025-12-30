import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/pages/auth_page.dart';
import 'package:unite_up/pages/settings_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/profile_header.dart';
import 'package:unite_up/widgets/profile_menu_item.dart';
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

  PreferredSizeWidget _buildAppBar(bool isAuthenticated) {
    return CustomAppBar(
      title: 'profile.title'.tr(),
      showBackButton: false,
      actions: isAuthenticated
          ? [
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

  Widget _buildAuthView() {
    return const AuthPage();
  }

  Widget _buildProfileView(AppStateProvider appState) {
    final user = appState.currentUser!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        children: [
          ProfileHeader(name: user.name, email: user.email),
          const SizedBox(height: AppSizes.spacing32),
          _buildStatsRow(appState),
          const SizedBox(height: AppSizes.spacing32),
          _buildMenuItems(),
          const SizedBox(height: AppSizes.spacing32),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppStateProvider appState) {
    final user = appState.currentUser!;
    final userId = user.id;

    // Count total goals across all challenges for this user
    int totalGoals = 0;
    for (final challenge in appState.challenges) {
      totalGoals += challenge.goals.where((g) => g.userId == userId).length;
    }

    // Count challenges
    final challengesCount = appState.challenges.length;

    // Followers count from user model
    final followersCount = user.followersCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatCard(
          value: totalGoals.toString(),
          label: 'profile.stats.goals'.tr(),
        ),
        ProfileStatCard(
          value: challengesCount.toString(),
          label: 'profile.stats.challenges'.tr(),
        ),
        ProfileStatCard(
          value: followersCount.toString(),
          label: 'profile.stats.followers'.tr(),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ProfileMenuItem(
          icon: AppIcons.trophy,
          title: 'profile.menu.achievements'.tr(),
          subtitle: 'profile.menu.viewAccomplishments'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: AppIcons.stats,
          title: 'profile.menu.statistics'.tr(),
          subtitle: 'profile.menu.trackProgress'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: AppIcons.notifications,
          title: 'profile.menu.notifications'.tr(),
          subtitle: 'profile.menu.manageAlerts'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: AppIcons.settings,
          title: 'profile.menu.settings'.tr(),
          subtitle: 'profile.menu.appPreferences'.tr(),
          onTap: _navigateToSettings,
        ),
      ],
    );
  }
}
