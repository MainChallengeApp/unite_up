import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/event_card.dart';
import 'package:unite_up/widgets/progress_dialog.dart';
import 'package:unite_up/widgets/upload_selection_sheet.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
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
      backgroundColor: Colors.transparent,
    ).then((result) {
      if (result != null && mounted) {
        // Handle the upload type selection
        // For now, just show the progress dialog
        _showProgressDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final challenge = appState.currentChallenge;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (challenge != null) ...[
                    Row(
                      children: [
                        Container(
                          width: AppSizes.iconXXLarge,
                          height: AppSizes.iconXXLarge,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: AppOpacity.light,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              challenge.emoji,
                              style: const TextStyle(
                                fontSize: AppSizes.fontLarge,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing8),
                        Flexible(
                          child: Text(
                            challenge.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.fontLarge,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (challenge.isGroup)
                      Text(
                        'challenges.member'.tr(
                          namedArgs: {
                            'count': challenge.memberCount.toString(),
                          },
                        ),
                        style: TextStyle(
                          fontSize: AppSizes.fontSmall,
                          fontWeight: FontWeight.normal,
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.mostlyOpaque,
                          ),
                        ),
                      ),
                  ] else
                    Text(
                      'chat.title'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.fontLarge,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: appState.events.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: AppSizes.spacing16,
                      bottom: AppSizes.spacing16,
                    ),
                    itemCount: appState.events.length,
                    itemBuilder: (context, index) {
                      final event = appState.events[index];
                      return EventCard(
                        event: event,
                        onChallengeAccept: null,
                        onSubmitProgress: _showProgressDialog,
                      );
                    },
                  ),
          ),
          _buildInputBar(theme, appState),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSizes.containerLarge,
            height: AppSizes.containerLarge,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: AppOpacity.light,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.chat,
              size: AppSizes.iconXXLarge,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSizes.spacing24),
          Text(
            'chat.startDocumenting'.tr(),
            style: TextStyle(
              fontSize: AppSizes.fontXXLarge,
              fontWeight: FontWeight.w600,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'chat.shareUpdates'.tr(),
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: theme.iconTheme.color?.withValues(
                alpha: AppOpacity.mostlyOpaque,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, AppStateProvider appState) {
    if (!appState.hasCompletedOnboarding) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: AppOpacity.light),
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Material(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
              child: InkWell(
                onTap: _showUploadOptions,
                borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
                child: Container(
                  width: AppSizes.containerSmall,
                  height: AppSizes.containerSmall,
                  alignment: Alignment.center,
                  child: Icon(
                    AppIcons.add,
                    color: theme.colorScheme.primary,
                    size: AppSizes.iconMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
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
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'chat.shareAnUpdate'.tr(),
                    hintStyle: TextStyle(
                      color: theme.iconTheme.color?.withValues(
                        alpha: AppOpacity.semiTransparent,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                    fontSize: AppSizes.fontBase,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacing12),
            Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
                child: Container(
                  width: AppSizes.containerSmall,
                  height: AppSizes.containerSmall,
                  alignment: Alignment.center,
                  child: const Icon(
                    AppIcons.send,
                    color: Colors.white,
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
