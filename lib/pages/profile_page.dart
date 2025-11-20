import 'package:dare_u/widgets/auth_form.dart';
import 'package:dare_u/widgets/profile_header.dart';
import 'package:dare_u/widgets/profile_menu_item.dart';
import 'package:dare_u/widgets/profile_stat_card.dart';
import 'package:flutter/material.dart';

import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggedIn = false;
  bool _isLoginMode = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleAuth() {
    setState(() => _isLoggedIn = true);
    _showSnackBar(
      _isLoginMode
          ? 'Successfully logged in!'
          : 'Account created successfully!',
    );
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
    _showSnackBar('Logged out successfully');
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoggedIn ? _buildProfileView() : _buildAuthView(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      actions: _isLoggedIn
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
    return AuthForm(
      isLoginMode: _isLoginMode,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      onSubmit: _handleAuth,
      onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileHeader(
            name: _nameController.text.isEmpty
                ? 'Demo User'
                : _nameController.text,
            email: _emailController.text.isEmpty
                ? 'demo@dareU.com'
                : _emailController.text,
          ),
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
