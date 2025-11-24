import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/services/user_service.dart';
import 'package:unite_up/widgets/create_goal_dialog.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/custom_bottom_sheet.dart';

class GroupDetailsPage extends StatelessWidget {
  final ChallengeChatModel challenge;

  const GroupDetailsPage({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final currentUserId = appState.currentUser?.id ?? 'user-1';
    final allUsers = UserModelService.getMockUserModels();

    // Get the latest challenge data from the provider
    final currentChallenge = appState.challenges.firstWhere(
      (c) => c.id == challenge.id,
      orElse: () => challenge,
    );

    // Get members of this challenge
    var members = allUsers
        .where((u) => currentChallenge.memberIds.contains(u.id))
        .toList();

    // Add current user if they're not in the mock list but are in challenge
    if (appState.currentUser != null &&
        currentChallenge.memberIds.contains(currentUserId) &&
        !members.any((m) => m.id == currentUserId)) {
      final currentUser = appState.currentUser!;
      members.insert(
        0,
        UserModel(
          id: currentUser.id,
          name: currentUser.displayName,
          username: '@${currentUser.email.split('@')[0]}',
          followersCount: 0,
          followingCount: 0,
          completedChallengesCount: 0,
        ),
      );
    }

    // Ensure current user always appears for personal challenges
    if (currentChallenge.isPersonal && members.isEmpty) {
      final currentUser = appState.currentUser;
      if (currentUser != null) {
        members.add(
          UserModel(
            id: currentUser.id,
            name: currentUser.displayName,
            username: '@${currentUser.email.split('@')[0]}',
            followersCount: 0,
            followingCount: 0,
            completedChallengesCount: 0,
          ),
        );
      } else {
        // Fallback for non-authenticated users
        members.add(
          UserModel(
            id: currentUserId,
            name: 'You',
            username: '@user',
            followersCount: 0,
            followingCount: 0,
            completedChallengesCount: 0,
          ),
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: challenge.isGroup
            ? 'goals.groupDetails'.tr()
            : 'goals.challengeDetails'.tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                _showChallengeOptions(context, currentChallenge, theme),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge Info
            _buildChallengeInfo(context, theme, currentChallenge),
            const SizedBox(height: AppSizes.spacing24),

            // Members and their goals
            Text(
              currentChallenge.isGroup
                  ? 'goals.membersAndGoals'.tr()
                  : 'goals.myGoals'.tr(),
              style: AppTextStyles.xLargeSemiBold.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.darkSurface,
              ),
            ),
            const SizedBox(height: AppSizes.spacing16),

            ...members.map(
              (member) => _buildMemberCard(
                context,
                theme,
                member,
                currentChallenge.goals
                    .where((g) => g.userId == member.id)
                    .toList(),
                member.id == currentUserId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeInfo(
    BuildContext context,
    ThemeData theme,
    ChallengeChatModel currentChallenge,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.containerMedium,
            height: AppSizes.containerMedium,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: AppOpacity.light,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                currentChallenge.emoji,
                style: AppTextStyles.emojiLarge,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentChallenge.name, style: AppTextStyles.largeSemiBold),
                if (currentChallenge.description != null) ...[
                  const SizedBox(height: AppSizes.spacing4),
                  Text(
                    currentChallenge.description!,
                    style: AppTextStyles.secondaryText(
                      context,
                      fontSize: AppSizes.fontMedium,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    ThemeData theme,
    UserModel member,
    List<GoalModel> goals,
    bool isCurrentUser,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing16),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: isCurrentUser
            ? Border.all(
                color: theme.colorScheme.primary.withValues(
                  alpha: AppOpacity.medium,
                ),
                width: AppSizes.borderMedium,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.spacing20,
                child: Text(member.name[0], style: AppTextStyles.baseLarge),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(member.name, style: AppTextStyles.largeSemiBold),
                        if (isCurrentUser) ...[
                          const SizedBox(width: AppSizes.spacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacing8,
                              vertical: AppSizes.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: AppOpacity.light,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSmall,
                              ),
                            ),
                            child: Text(
                              'common.you'.tr(),
                              style: AppTextStyles.smallMedium.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      member.username,
                      style: AppTextStyles.secondaryText(
                        context,
                        fontSize: AppSizes.fontMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrentUser)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: IconButton(
                    icon: const Icon(AppIcons.add, color: AppColors.white),
                    onPressed: () => _showCreateGoalDialog(context),
                    tooltip: 'goals.addGoal'.tr(),
                  ),
                ),
            ],
          ),
          if (isCurrentUser && goals.isEmpty) ...[
            const SizedBox(height: AppSizes.spacing16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCreateGoalDialog(context),
                icon: const Icon(AppIcons.add),
                label: Text('goals.addFirstGoal'.tr()),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSizes.spacing12),
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ],
          if (goals.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacing16),
            const Divider(),
            const SizedBox(height: AppSizes.spacing8),
            ...goals.map((goal) => _buildGoalItem(context, theme, goal)),
          ] else if (!isCurrentUser) ...[
            const SizedBox(height: AppSizes.spacing12),
            Center(
              child: Text(
                'goals.noGoalsForUser'.tr(),
                style: AppTextStyles.hintText(
                  context,
                  fontSize: AppSizes.fontMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, ThemeData theme, GoalModel goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      padding: const EdgeInsets.all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(goal.title, style: AppTextStyles.mediumWeight),
              ),
              Text(
                '${goal.progressPercentage.toStringAsFixed(0)}%',
                style: AppTextStyles.largeSemiBold.copyWith(
                  color: goal.isCompleted
                      ? AppColors.green
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            child: LinearProgressIndicator(
              value: goal.progressPercentage / 100,
              minHeight: AppSizes.spacing8,
              backgroundColor: theme.dividerColor.withValues(
                alpha: AppOpacity.light,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                goal.isCompleted ? AppColors.green : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Start value
              Text(
                '${_formatValue(goal.startValue)} ${goal.unit ?? ""}',
                style: AppTextStyles.smallSecondary(context),
              ),
              // Days remaining
              Text(
                goal.isCompleted
                    ? 'goals.completed'.tr()
                    : goal.isOverdue
                    ? 'goals.overdue'.tr()
                    : 'goals.daysLeft'.tr(
                        namedArgs: {'days': goal.daysRemaining.toString()},
                      ),
                style: AppTextStyles.smallMedium.copyWith(
                  color: goal.isCompleted
                      ? AppColors.green
                      : goal.isOverdue
                      ? AppColors.red
                      : theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.mostlyOpaque,
                        ),
                ),
              ),
              // End value (goal)
              Text(
                '${_formatValue(goal.endValue)} ${goal.unit ?? ""}',
                style: AppTextStyles.smallSecondary(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateGoalDialog(),
    );
  }

  void _showChallengeOptions(
    BuildContext context,
    ChallengeChatModel currentChallenge,
    ThemeData theme,
  ) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomBottomSheet(
        options: [
          BottomSheetOption(
            icon: AppIcons.edit,
            label: 'common.edit'.tr(),
            color: theme.colorScheme.primary,
            onTap: () {
              Navigator.pop(context);
              _showEditChallengeDialog(context, currentChallenge);
            },
          ),
          BottomSheetOption(
            icon: AppIcons.close,
            label: 'common.delete'.tr(),
            color: AppColors.red,
            onTap: () {
              Navigator.pop(context);
              _showDeleteChallengeConfirmation(context, currentChallenge);
            },
          ),
        ],
      ),
    );
  }

  void _showEditChallengeDialog(
    BuildContext context,
    ChallengeChatModel currentChallenge,
  ) {
    final nameController = TextEditingController(text: currentChallenge.name);
    final descriptionController = TextEditingController(
      text: currentChallenge.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('challenges.edit'.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'challenges.create.titleLabel'.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spacing16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'challenges.create.descriptionLabel'.tr(),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final updatedChallenge = currentChallenge.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
                Provider.of<AppStateProvider>(
                  context,
                  listen: false,
                ).updateChallenge(updatedChallenge);
                Navigator.pop(context);
              }
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }

  void _showDeleteChallengeConfirmation(
    BuildContext context,
    ChallengeChatModel currentChallenge,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('challenges.delete'.tr()),
        content: Text('challenges.deleteConfirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<AppStateProvider>(
                context,
                listen: false,
              ).deleteChallenge(currentChallenge.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close group details
              Navigator.pop(context); // Close chat page
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}
