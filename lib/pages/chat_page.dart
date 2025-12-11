import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/dialogs/create_goal_dialog.dart';
import 'package:unite_up/dialogs/progress_dialog.dart';
import 'package:unite_up/dialogs/update_goal_progress_dialog.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/pages/group_details_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/widgets/event_card.dart';
import 'package:unite_up/widgets/upload_selection_sheet.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  ThemeData get _theme => Theme.of(context);

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final challenge = appState.currentChallenge;
    final hasGoal = _userHasGoal(appState);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(titleWidget: _buildAppBarTitleWidget(challenge)),
        body: Column(
          children: [
            if (!hasGoal) _buildCreateGoalBanner(),
            Expanded(
              child: appState.events.isEmpty
                  ? _buildEmptyState()
                  : _buildChatList(appState),
            ),
            _buildInputBar(appState),
          ],
        ),
      ),
    );
  }

  bool _userHasGoal(AppStateProvider appState) {
    final userId = appState.currentUser?.id ?? AppStateProvider.anonymousUserId;
    final userGoals = appState.getGoalsForUser(userId);
    return userGoals.isNotEmpty;
  }

  Widget _buildCreateGoalBanner() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _theme.colorScheme.primary,
            _theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: _theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: AppSizes.blurMedium,
            offset: AppSizes.shadowOffsetSmall,
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: _showCreateGoalDialog,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                Container(
                  width: AppSizes.iconXXLarge,
                  height: AppSizes.iconXXLarge,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.flag,
                    color: AppColors.white,
                    size: AppSizes.iconLarge,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'chat.setYourGoal'.tr(),
                        style: AppTextStyles.largeSemiBold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        'chat.setYourGoalDescription'.tr(),
                        style: AppTextStyles.baseSmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.arrowForward,
                    color: AppColors.white,
                    size: AppSizes.iconSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitleWidget(challenge) {
    return InkWell(
      onTap: challenge != null
          ? () => _navigateToGroupDetails(challenge)
          : null,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
        child: _buildChallengeInfo(challenge),
      ),
    );
  }

  Widget _buildChallengeInfo(challenge) {
    return Row(
      children: [
        if (challenge != null) ...[
          _buildChallengeEmoji(challenge),
          const SizedBox(width: AppSizes.spacing12),
          _buildChallengeDetails(challenge),
        ],
      ],
    );
  }

  Widget _buildChallengeEmoji(challenge) {
    return Container(
      width: AppSizes.iconXLarge,
      height: AppSizes.iconXLarge,
      decoration: BoxDecoration(
        color: _theme.colorScheme.primary.withValues(alpha: AppOpacity.light),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(challenge.emoji, style: AppTextStyles.baseMedium),
      ),
    );
  }

  Widget _buildChallengeDetails(challenge) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            challenge.name,
            style: AppTextStyles.largeSemiBold,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (challenge.isGroup) ...[
            const SizedBox(height: AppSizes.spacing2),
            Text(
              'challenges.member'.tr(
                namedArgs: {'count': challenge.memberCount.toString()},
              ),
              style: AppTextStyles.smallSecondary(context),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToGroupDetails(challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailsPage(challenge: challenge),
      ),
    );
  }

  void _showProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => const ProgressDialog(),
    ).then((result) {
      if (result != null && result is ProgressEntryModel && mounted) {
        Provider.of<AppStateProvider>(
          context,
          listen: false,
        ).submitProgress(result);
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).addMessage(_messageController.text.trim());
    _messageController.clear();
    _animateToBottom();
  }

  void _animateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: AppDurations.animationNormal,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const UploadSelectionSheet(),
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
    ).then((result) {
      if (result != null && mounted) {
        if (result == 'create_goal') {
          _showCreateGoalDialog();
        } else if (result == 'goal_progress') {
          _showUpdateGoalProgressDialog();
        } else {
          // Handle other upload type selections
          // For now, just show the progress dialog for media uploads
          _showProgressDialog();
        }
      }
    });
  }

  void _showCreateGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateGoalDialog(),
    );
  }

  void _showUpdateGoalProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => const UpdateGoalProgressDialog(),
    );
  }

  Widget _buildChatList(AppStateProvider appState) {
    final events = appState.events;
    final groupedEvents = _groupEventsByDate(events);
    final itemCount = _calculateItemCount(groupedEvents);

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSizes.spacing16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _buildListItemReversed(context, groupedEvents, index);
      },
    );
  }

  Map<String, List<EventModel>> _groupEventsByDate(List<EventModel> events) {
    final Map<String, List<EventModel>> grouped = {};

    for (final event in events) {
      final dateKey = DateFormat('yyyy-MM-dd').format(event.timestamp);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(event);
    }

    return grouped;
  }

  int _calculateItemCount(Map<String, List<EventModel>> groupedEvents) {
    int count = 0;
    for (final entries in groupedEvents.values) {
      count += 1 + entries.length; // 1 for date header + events
    }
    return count;
  }

  Widget _buildListItemReversed(
    BuildContext context,
    Map<String, List<EventModel>> groupedEvents,
    int index,
  ) {
    int currentIndex = 0;
    final reversedEntries = groupedEvents.entries.toList().reversed;

    for (final entry in reversedEntries) {
      final reversedEvents = entry.value.reversed.toList();

      // Events first (newest at index 0)
      for (final event in reversedEvents) {
        if (currentIndex == index) {
          return EventCard(
            event: event,
            onChallengeAccept: null,
            onSubmitProgress: _showProgressDialog,
          );
        }
        currentIndex++;
      }

      // Date header after events
      if (currentIndex == index) {
        return _buildDateHeader(entry.key);
      }
      currentIndex++;
    }

    return const SizedBox.shrink();
  }

  Widget _buildDateHeader(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final eventDate = DateTime(date.year, date.month, date.day);

    String displayText;
    if (eventDate == today) {
      displayText = 'chat.today'.tr();
    } else if (eventDate == yesterday) {
      displayText = 'chat.yesterday'.tr();
    } else {
      displayText = DateFormat('MMMM dd, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing8,
          ),
          decoration: BoxDecoration(
            color: _theme.colorScheme.primary.withValues(
              alpha: AppOpacity.veryLight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Text(
            displayText,
            style: AppTextStyles.smallMedium.copyWith(
              color: _theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.containerLarge,
            height: AppSizes.containerLarge,
            decoration: BoxDecoration(
              color: _theme.colorScheme.primary.withValues(
                alpha: AppOpacity.light,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.chat,
              size: AppSizes.iconXXLarge,
              color: _theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          Text(
            'chat.startDocumenting'.tr(),
            style: AppTextStyles.xxLargeSemiBold.copyWith(
              color: _theme.brightness == Brightness.dark
                  ? AppColors.white
                  : AppColors.darkSurface,
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'chat.shareUpdates'.tr(),
            style: AppTextStyles.secondaryText(
              context,
              fontSize: AppSizes.fontMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(AppStateProvider appState) {
    if (!appState.hasCompletedOnboarding) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing12,
      ),
      decoration: BoxDecoration(
        color: _theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: _theme.dividerColor.withValues(alpha: AppOpacity.light),
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              color: _theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: InkWell(
                onTap: _showUploadOptions,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                child: Container(
                  width: AppSizes.containerSmall,
                  height: AppSizes.containerSmall,
                  alignment: Alignment.center,
                  child: Icon(
                    AppIcons.add,
                    color: _theme.colorScheme.primary,
                    size: AppSizes.iconMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(
                        alpha: AppOpacity.veryLight,
                      ),
                      blurRadius: AppSizes.blurMedium,
                      offset: AppSizes.shadowOffsetSmall,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  maxLength: AppTextLimits.messageMaxLength,
                  buildCounter:
                      (
                        context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) => null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'chat.shareAnUpdate'.tr(),
                    hintStyle: AppTextStyles.hintText(
                      context,
                      fontSize: AppSizes.fontBase,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: AppTextStyles.baseTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacing12),
            Material(
              color: _theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                child: Container(
                  width: AppSizes.containerSmall,
                  height: AppSizes.containerSmall,
                  alignment: Alignment.center,
                  child: const Icon(
                    AppIcons.send,
                    color: AppColors.white,
                    size: AppSizes.iconMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
