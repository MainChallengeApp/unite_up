import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildAvatar(theme),
        const SizedBox(height: 20),
        _buildName(theme),
        const SizedBox(height: 4),
        _buildEmail(theme),
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.3),
            theme.colorScheme.secondary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: 50,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildName(ThemeData theme) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: theme.brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildEmail(ThemeData theme) {
    return Text(
      email,
      style: TextStyle(
        fontSize: 14,
        color: theme.iconTheme.color?.withOpacity(0.6),
      ),
    );
  }
}

