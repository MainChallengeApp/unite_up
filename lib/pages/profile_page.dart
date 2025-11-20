import 'package:dare_u/pages/auth_page.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/widgets/profile_header.dart';
import 'package:dare_u/widgets/profile_menu_item.dart';
import 'package:dare_u/widgets/profile_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _handleLogout() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    try {
      await appState.signOut();
      _showSnackBar('Logged out successfully');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

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
      title: const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      actions: isAuthenticated
          ? [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: _navigateToSettings,
                tooltip: 'Settings',
              ),
              const SizedBox(width: 8),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileHeader(name: user.displayName, email: user.email),
          const SizedBox(height: 32),
          _buildStatsRow(),
          const SizedBox(height: 32),
          _buildMenuItems(),
          const SizedBox(height: 32),
          _buildLogoutButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileStatCard(value: '12', label: 'Goals'),
        ProfileStatCard(value: '89', label: 'Challenges'),
        ProfileStatCard(value: '245', label: 'Followers'),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.emoji_events_rounded,
          title: 'Achievements',
          subtitle: 'View your accomplishments',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.bar_chart_rounded,
          title: 'Statistics',
          subtitle: 'Track your progress',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage your alerts',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: _navigateToSettings,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _handleLogout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: theme.colorScheme.error, width: 1.5),
          foregroundColor: theme.colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
