import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/pages/group_details_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';
import 'package:unite_up/dialogs/create_goal_dialog.dart';
import 'package:unite_up/dialogs/progress_dialog.dart';
import 'package:unite_up/dialogs/update_goal_progress_dialog.dart';
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
  void initState() {
    super.initState();
    // Scroll to bottom after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(titleWidget: _buildAppBarTitleWidget(challenge)),
        body: Column(
          children: [
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

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
      if (animated) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
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
        _scrollToBottom();
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
    _scrollToBottom();
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
    final groupedEvents = _groupEventsByDate(appState.events);

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
      itemCount: _calculateItemCount(groupedEvents),
      itemBuilder: (context, index) {
        return _buildListItem(context, groupedEvents, index);
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

  Widget _buildListItem(
    BuildContext context,
    Map<String, List<EventModel>> groupedEvents,
    int index,
  ) {
    int currentIndex = 0;

    for (final entry in groupedEvents.entries) {
      // Date header
      if (currentIndex == index) {
        return _buildDateHeader(entry.key);
      }
      currentIndex++;

      // Events for this date
      for (final event in entry.value) {
        if (currentIndex == index) {
          return EventCard(
            event: event,
            onChallengeAccept: null,
            onSubmitProgress: _showProgressDialog,
          );
        }
        currentIndex++;
      }
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
