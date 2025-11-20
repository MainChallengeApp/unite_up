import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/widgets/auth_form.dart';
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
  bool _isLoginMode = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
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

  Future<void> _handleEmailAuth() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    if (!_isLoginMode && _nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await appState.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        _showSnackBar('Successfully logged in!');
      } else {
        await appState.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
        _showSnackBar('Account created successfully!');
      }

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isGoogleLoading = true);

    try {
      await appState.signInWithGoogle();
      _showSnackBar('Signed in with Google!');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isAppleLoading = true);

    try {
      await appState.signInWithApple();
      _showSnackBar('Signed in with Apple!');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await appState.signOut();
      _showSnackBar('Logged out successfully');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
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
    return AuthForm(
      isLoginMode: _isLoginMode,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      onSubmit: _handleEmailAuth,
      onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
      onGoogleSignIn: _handleGoogleSignIn,
      onAppleSignIn: _handleAppleSignIn,
      isLoading: _isLoading,
      isGoogleLoading: _isGoogleLoading,
      isAppleLoading: _isAppleLoading,
    );
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
