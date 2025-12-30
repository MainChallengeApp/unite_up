import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/users_provider.dart';

/// A wrapper widget that positions event cards on the left or right
/// based on whether the event is from the current user or another user.
class EventCardWrapper extends StatelessWidget {
  final EventModel event;
  final Widget child;

  /// If true, the card will always be centered (full width).
  /// Use this for system events that don't belong to any user.
  final bool alwaysCentered;

  const EventCardWrapper({
    super.key,
    required this.event,
    required this.child,
    this.alwaysCentered = false,
  });

  bool _isFromCurrentUser(BuildContext context) {
    if (event.userId == null) return true; // System events show on right
    final currentUserId = Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).currentUser?.id;
    return event.userId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    if (alwaysCentered) {
      return child;
    }

    final isFromCurrentUser = _isFromCurrentUser(context);

    if (isFromCurrentUser) {
      return _buildCurrentUserLayout(child);
    } else {
      return _buildOtherUserLayout(context, child);
    }
  }

  /// Layout for current user's events - aligned to the right with spacer on left
  Widget _buildCurrentUserLayout(Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: AppSizes.spacing48),
          Expanded(child: content),
        ],
      ),
    );
  }

  /// Layout for other users' events - aligned to the left with avatar
  Widget _buildOtherUserLayout(BuildContext context, Widget content) {
    final theme = Theme.of(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    return FutureBuilder(
      future: event.userId != null
          ? usersProvider.getUserById(event.userId!)
          : Future.value(null),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final userInitial = user != null ? user.name[0].toUpperCase() : '?';

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
              // Event content
              Expanded(child: content),
              const SizedBox(width: AppSizes.spacing48),
            ],
          ),
        );
      },
    );
  }
}
