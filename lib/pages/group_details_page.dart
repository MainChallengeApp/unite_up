import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/dialogs/create_goal_dialog.dart';
import 'package:unite_up/dialogs/delete_challenge_dialog.dart';
import 'package:unite_up/dialogs/delete_goal_dialog.dart';
import 'package:unite_up/dialogs/edit_goal_dialog.dart';
import 'package:unite_up/dialogs/quick_update_progress_dialog.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/user_model.dart';
import 'package:unite_up/pages/create_challenge_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/providers/users_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/custom_bottom_sheet.dart';
import 'package:unite_up/widgets/custom_slidable_action_button.dart';
import 'package:unite_up/widgets/empty_state.dart';

class GroupDetailsPage extends StatefulWidget {
  final ChallengeChatModel challenge;

  const GroupDetailsPage({super.key, required this.challenge});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<UserModel> _members = [];
  bool _isLoadingMembers = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.animationNormal,
      vsync: this,
    )..forward();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUserId =
        appState.currentUser?.id ?? AppStateProvider.anonymousUserId;

    final currentChallenge = appState.challenges.firstWhere(
      (c) => c.id == widget.challenge.id,
      orElse: () => widget.challenge,
    );

    final members = <UserModel>[];

    // For personal challenges, just add current user
    if (currentChallenge.isPersonal) {
      final currentUser = appState.currentUser;
      if (currentUser != null) {
        members.add(currentUser);
      } else {
        final now = DateTime.now();
        members.add(
          UserModel(
            id: currentUserId,
            email: 'anonymous@local',
            displayName: 'You',
            username: '@user',
            authProvider: 'anonymous',
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    } else {
      // For group challenges, fetch members from database
      for (final memberId in currentChallenge.memberIds) {
        if (memberId == currentUserId && appState.currentUser != null) {
          members.add(appState.currentUser!);
        } else {
          final user = await usersProvider.getUserById(memberId);
          if (user != null) {
            members.add(user);
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _members = members;
        _isLoadingMembers = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final currentUserId =
        appState.currentUser?.id ?? AppStateProvider.anonymousUserId;

    // Get the latest challenge data from the provider
    final currentChallenge = appState.challenges.firstWhere(
      (c) => c.id == widget.challenge.id,
      orElse: () => widget.challenge,
    );

    final members = _members;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'goals.challengeDetails'.tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                _showChallengeOptions(context, currentChallenge, theme),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Challenge Info with enhanced visual design
              _buildChallengeHeader(context, theme, currentChallenge),
              const SizedBox(height: AppSizes.spacing20),

              // Hero Stats Section
              _buildHeroStatsSection(context, theme, currentChallenge),
              const SizedBox(height: AppSizes.spacing24),

              // Members and their goals section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  if (currentChallenge.goals.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing12,
                        vertical: AppSizes.spacing6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: AppOpacity.light,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusLarge,
                        ),
                      ),
                      child: Text(
                        '${currentChallenge.goals.length}',
                        style: AppTextStyles.mediumSemiBold.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing16),

              // Member cards
              if (_isLoadingMembers)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.spacing32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (members.isEmpty)
                _buildEmptyMembersState(context, theme)
              else
                ...members.asMap().entries.map((entry) {
                  final index = entry.key;
                  final member = entry.value;
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              index * 0.1,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                    child: _buildMemberCard(
                      context,
                      theme,
                      member,
                      currentChallenge.goals
                          .where((g) => g.userId == member.id)
                          .toList(),
                      member.id == currentUserId,
                      currentChallenge,
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeHeader(
    BuildContext context,
    ThemeData theme,
    ChallengeChatModel currentChallenge,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: AppSizes.borderThin,
        ),
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
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: AppSizes.blurMedium,
                  offset: const Offset(0, 2),
                ),
              ],
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
                Text(
                  currentChallenge.name,
                  style: AppTextStyles.largeSemiBold.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.white
                        : AppColors.darkSurface,
                  ),
                ),
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
                const SizedBox(height: AppSizes.spacing8),
                Row(
                  children: [
                    Icon(
                      currentChallenge.isPersonal
                          ? AppIcons.personOutline
                          : AppIcons.people,
                      size: AppSizes.iconSmall,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.spacing4),
                    Text(
                      currentChallenge.isPersonal
                          ? 'challenges.personal'.tr()
                          : '${currentChallenge.memberCount} ${'challenges.members'.tr()}',
                      style: AppTextStyles.smallMedium.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatsSection(
    BuildContext context,
    ThemeData theme,
    ChallengeChatModel currentChallenge,
  ) {
    final totalGoals = currentChallenge.goals.length;
    final completedGoals = currentChallenge.goals
        .where((g) => g.isCompleted)
        .length;
    final overallProgress = totalGoals > 0
        ? currentChallenge.goals
                  .map((g) => g.progressPercentage)
                  .reduce((a, b) => a + b) /
              totalGoals
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            icon: AppIcons.flag,
            label: 'goals.totalGoals'.tr(),
            value: totalGoals.toString(),
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            icon: AppIcons.checkCircle,
            label: 'goals.completed'.tr(),
            value: completedGoals.toString(),
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _buildStatCard(
            context,
            theme,
            icon: AppIcons.stats,
            label: 'goals.progress'.tr(),
            value: '${overallProgress.toStringAsFixed(0)}%',
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: AppOpacity.subtle),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: AppSizes.blurSmall,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppSizes.iconLarge, color: color),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            value,
            style: AppTextStyles.xLargeSemiBold.copyWith(
              color: theme.brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.darkSurface,
            ),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            label,
            style: AppTextStyles.smallSecondary(context),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMembersState(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing32),
      child: EmptyState(
        icon: AppIcons.people,
        title: 'goals.noMembers'.tr(),
        subtitle: 'goals.noMembersSubtitle'.tr(),
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    ThemeData theme,
    UserModel member,
    List<GoalModel> goals,
    bool isCurrentUser,
    ChallengeChatModel currentChallenge,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing16),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: isCurrentUser
              ? theme.colorScheme.primary.withValues(alpha: AppOpacity.medium)
              : theme.dividerColor.withValues(alpha: AppOpacity.subtle),
          width: isCurrentUser ? AppSizes.borderMedium : AppSizes.borderThin,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: AppSizes.blurMedium,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag: 'member_${member.id}',
                child: CircleAvatar(
                  radius: AppSizes.spacing24,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: AppOpacity.light,
                  ),
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: AppTextStyles.largeSemiBold.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.name,
                            style: AppTextStyles.largeSemiBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                      '@${member.username}',
                      style: AppTextStyles.secondaryText(
                        context,
                        fontSize: AppSizes.fontMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrentUser)
                Material(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  elevation: AppSizes.elevationLow,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showCreateGoalDialog(context);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.spacing12),
                      child: const Icon(
                        AppIcons.add,
                        color: AppColors.white,
                        size: AppSizes.iconMedium,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (isCurrentUser && goals.isEmpty) ...[
            const SizedBox(height: AppSizes.spacing16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spacing16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: AppSizes.borderThin,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    AppIcons.flag,
                    size: AppSizes.iconXLarge,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSizes.spacing8),
                  Text(
                    'goals.noGoalsYet'.tr(),
                    style: AppTextStyles.mediumSemiBold.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  Text(
                    'goals.addFirstGoalSubtitle'.tr(),
                    style: AppTextStyles.smallSecondary(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showCreateGoalDialog(context);
                    },
                    icon: const Icon(AppIcons.add, size: AppSizes.iconSmall),
                    label: Text('goals.addFirstGoal'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing16,
                        vertical: AppSizes.spacing12,
                      ),
                      elevation: AppSizes.elevationNone,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (goals.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacing16),
            Divider(
              color: theme.dividerColor.withValues(alpha: AppOpacity.subtle),
            ),
            const SizedBox(height: AppSizes.spacing8),
            ...goals.map(
              (goal) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
                child: _buildGoalItem(
                  context,
                  theme,
                  goal,
                  isCurrentUser,
                  currentChallenge,
                ),
              ),
            ),
          ] else if (!isCurrentUser) ...[
            const SizedBox(height: AppSizes.spacing16),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spacing16),
                child: Column(
                  children: [
                    Icon(
                      AppIcons.flag,
                      size: AppSizes.iconXLarge,
                      color: theme.iconTheme.color?.withValues(
                        alpha: AppOpacity.medium,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      'goals.noGoalsForUser'.tr(),
                      style: AppTextStyles.secondaryText(
                        context,
                        fontSize: AppSizes.fontMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalItem(
    BuildContext context,
    ThemeData theme,
    GoalModel goal,
    bool isCurrentUser,
    ChallengeChatModel currentChallenge,
  ) {
    final goalCard = InkWell(
      onTap: isCurrentUser
          ? () {
              HapticFeedback.lightImpact();
              _showQuickUpdateProgress(context, goal);
            }
          : null,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        // margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: goal.isCompleted
                ? AppColors.green.withValues(alpha: 0.3)
                : theme.dividerColor.withValues(alpha: AppOpacity.subtle),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.03),
              blurRadius: AppSizes.blurSmall,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (goal.isCompleted)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppSizes.spacing8,
                              ),
                              child: Icon(
                                AppIcons.checkCircle,
                                size: AppSizes.iconSmall,
                                color: AppColors.green,
                              ),
                            ),
                          Flexible(
                            child: Text(
                              goal.title,
                              style: AppTextStyles.mediumWeight.copyWith(
                                decoration: goal.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        '${_formatValue(goal.currentValue)} / ${_formatValue(goal.endValue)} ${goal.unit ?? ""}',
                        style: AppTextStyles.smallSecondary(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing12,
                    vertical: AppSizes.spacing6,
                  ),
                  decoration: BoxDecoration(
                    color: goal.isCompleted
                        ? AppColors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: Text(
                    '${goal.progressPercentage.toStringAsFixed(0)}%',
                    style: AppTextStyles.mediumSemiBold.copyWith(
                      color: goal.isCompleted
                          ? AppColors.green
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),
            // Enhanced Progress bar with animation
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  child: LinearProgressIndicator(
                    value: goal.progressPercentage / 100,
                    minHeight: AppSizes.spacing10,
                    backgroundColor: theme.dividerColor.withValues(
                      alpha: AppOpacity.light,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      goal.isCompleted
                          ? AppColors.green
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Days remaining with icon
                Row(
                  children: [
                    Icon(
                      goal.isCompleted
                          ? AppIcons.checkCircle
                          : goal.isOverdue
                          ? AppIcons.info
                          : Icons.access_time_rounded,
                      size: AppSizes.iconSmall,
                      color: goal.isCompleted
                          ? AppColors.green
                          : goal.isOverdue
                          ? AppColors.red
                          : theme.iconTheme.color?.withValues(
                              alpha: AppOpacity.semiTransparent,
                            ),
                    ),
                    const SizedBox(width: AppSizes.spacing4),
                    Text(
                      goal.isCompleted
                          ? 'goals.completed'.tr()
                          : goal.isOverdue
                          ? 'goals.overdue'.tr()
                          : 'goals.daysLeft'.tr(
                              namedArgs: {
                                'days': goal.daysRemaining.toString(),
                              },
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
                  ],
                ),
                // Tap hint for current user
                if (isCurrentUser && !goal.isCompleted)
                  Row(
                    children: [
                      Icon(
                        AppIcons.edit,
                        size: AppSizes.iconSmall,
                        color: theme.iconTheme.color?.withValues(
                          alpha: AppOpacity.medium,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing4),
                      Text(
                        'goals.tapToUpdate'.tr(),
                        style: AppTextStyles.smallSecondary(context),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    // Add swipe actions for current user
    if (isCurrentUser) {
      return Slidable(
        key: Key(goal.id),
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: AppSizes.slidableExtentRatio,
          dragDismissible: false,
          children: [
            CustomSlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                _showEditGoalDialog(context, goal);
              },
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing8,
              ),
              child: CustomSlidableActionButton(
                icon: AppIcons.edit,
                color: theme.colorScheme.primary,
              ),
            ),
            CustomSlidableAction(
              onPressed: (_) {
                HapticFeedback.mediumImpact();
                _showDeleteGoalConfirmation(context, goal);
              },
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing8,
              ),
              child: const CustomSlidableActionButton(
                icon: AppIcons.delete,
                color: AppColors.red,
              ),
            ),
          ],
        ),
        child: goalCard,
      );
    }

    return goalCard;
  }

  void _showCreateGoalDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => const CreateGoalDialog(),
    );
  }

  void _showQuickUpdateProgress(BuildContext context, GoalModel goal) {
    showDialog(
      context: context,
      builder: (context) => QuickUpdateProgressDialog(goal: goal),
    );
  }

  void _showEditGoalDialog(BuildContext context, GoalModel goal) {
    showDialog(
      context: context,
      builder: (context) => EditGoalDialog(goal: goal),
    );
  }

  void _showDeleteGoalConfirmation(BuildContext context, GoalModel goal) {
    showDialog(
      context: context,
      builder: (context) => DeleteGoalDialog(goal: goal),
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
              _navigateToEditChallenge(context, currentChallenge);
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

  void _navigateToEditChallenge(
    BuildContext context,
    ChallengeChatModel challenge,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateChallengePage(challenge: challenge),
      ),
    );
  }

  void _showDeleteChallengeConfirmation(
    BuildContext context,
    ChallengeChatModel challenge,
  ) {
    showDialog(
      context: context,
      builder: (context) => DeleteChallengeDialog(challenge: challenge),
    );
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}
