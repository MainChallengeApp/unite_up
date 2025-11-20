import 'package:dare_u/pages/auth_page.dart';
import 'package:dare_u/core/constants/app_constants.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/widgets/profile_header.dart';
import 'package:dare_u/widgets/profile_menu_item.dart';
import 'package:dare_u/widgets/profile_stat_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: _buildAppBar(appState.isAuthenticated),
          body: appState.isAuthenticated
              ? _buildProfileView(appState)
              : _buildAuthView(),
        );
      },
    );
  }

  AppBar _buildAppBar(bool isAuthenticated) {
    return AppBar(
      title: Text(
        'profile.title'.tr(),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.fontXLarge),
      ),
      actions: isAuthenticated
          ? [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
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
          ProfileHeader(name: user.displayName, email: user.email),
          const SizedBox(height: AppSizes.spacing32),
          _buildStatsRow(),
          const SizedBox(height: AppSizes.spacing32),
          _buildMenuItems(),
          const SizedBox(height: AppSizes.spacing32),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatCard(value: '12', label: 'profile.stats.goals'.tr()),
        ProfileStatCard(value: '89', label: 'profile.stats.challenges'.tr()),
        ProfileStatCard(value: '245', label: 'profile.stats.followers'.tr()),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.emoji_events_rounded,
          title: 'profile.menu.achievements'.tr(),
          subtitle: 'profile.menu.viewAccomplishments'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: Icons.bar_chart_rounded,
          title: 'profile.menu.statistics'.tr(),
          subtitle: 'profile.menu.trackProgress'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: 'profile.menu.notifications'.tr(),
          subtitle: 'profile.menu.manageAlerts'.tr(),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.spacing12),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'profile.menu.settings'.tr(),
          subtitle: 'profile.menu.appPreferences'.tr(),
          onTap: _navigateToSettings,
        ),
      ],
    );
  }
}
