import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/pages/chat_page.dart';
import 'package:unite_up/pages/create_challenge_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isSelectionMode = false;
  final Set<String> _selectedChallengeIds = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _enterSelectionMode(String challengeId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSelectionMode = true;
      _selectedChallengeIds.add(challengeId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedChallengeIds.clear();
    });
  }

  void _toggleSelection(String challengeId) {
    setState(() {
      if (_selectedChallengeIds.contains(challengeId)) {
        _selectedChallengeIds.remove(challengeId);
        if (_selectedChallengeIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedChallengeIds.add(challengeId);
      }
    });
  }

  void _deleteSelectedChallenges(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('challenges.delete'.tr()),
        content: Text(
          'challenges.deleteMultipleConfirmation'.tr(
            namedArgs: {'count': _selectedChallengeIds.length.toString()},
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              final appState = Provider.of<AppStateProvider>(
                context,
                listen: false,
              );
              for (final id in _selectedChallengeIds) {
                appState.deleteChallenge(id);
              }
              Navigator.pop(context);
              _exitSelectionMode();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }

  void _navigateToChallengeChat(BuildContext context, String challengeId) {
    Provider.of<AppStateProvider>(
      context,
      listen: false,
    ).selectChallenge(challengeId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }

  void _createNewChallenge(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateChallengePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final challenges = appState.challenges;

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(AppIcons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
        title: Text(
          _isSelectionMode
              ? '${_selectedChallengeIds.length} ${'common.selected'.tr()}'
              : 'challenges.title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontXLarge,
          ),
        ),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(AppIcons.delete),
              onPressed: _selectedChallengeIds.isEmpty
                  ? null
                  : () => _deleteSelectedChallenges(context),
              tooltip: 'common.delete'.tr(),
            )
          else
            IconButton(
              icon: const Icon(AppIcons.add),
              onPressed: () => _createNewChallenge(context),
              tooltip: 'challenges.createNewChallenge'.tr(),
            ),
          const SizedBox(width: AppSizes.spacing8),
        ],
      ),
      body: challenges.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return _buildChallengeCard(context, challenges[index], theme);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon with heartbeat effect
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                          theme.colorScheme.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.flag,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.spacing32),
            // Title
            Text(
              'challenges.noChallengesYet'.tr(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing12),
            // Subtitle
            Text(
              'challenges.emptySubtitle'.tr(),
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                color: theme.iconTheme.color?.withValues(
                  alpha: AppOpacity.mostlyOpaque,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing40),
            // CTA Button
            ElevatedButton.icon(
              onPressed: () => _createNewChallenge(context),
              icon: const Icon(AppIcons.add, size: 22),
              label: Text(
                'challenges.createChallenge'.tr(),
                style: const TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing32,
                  vertical: AppSizes.spacing16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                elevation: AppSizes.elevationNone,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    ChallengeChatModel challenge,
    ThemeData theme,
  ) {
    final isSelected = _selectedChallengeIds.contains(challenge.id);

    final cardContent = Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      elevation: AppSizes.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.dividerColor.withValues(alpha: AppOpacity.subtle),
          width: isSelected ? 2.0 : AppSizes.borderThin,
        ),
      ),
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSelection(challenge.id)
            : () => _navigateToChallengeChat(context, challenge.id),
        onLongPress: _isSelectionMode
            ? null
            : () => _enterSelectionMode(challenge.id),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          child: Row(
            children: [
              Container(
                width: AppSizes.containerMedium,
                height: AppSizes.containerMedium,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(
                    alpha: AppOpacity.light,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: _isSelectionMode
                    ? Center(
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggleSelection(challenge.id),
                          shape: const CircleBorder(),
                        ),
                      )
                    : Center(
                        child: Text(
                          challenge.emoji,
                          style: const TextStyle(fontSize: AppSizes.emojiLarge),
                        ),
                      ),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name,
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    if (challenge.description != null &&
                        challenge.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        challenge.description!,
                        style: TextStyle(
                          fontSize: AppSizes.fontRegular,
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.mostlyOpaque,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSizes.spacing8),
                    Row(
                      children: [
                        Icon(
                          challenge.isPersonal
                              ? AppIcons.personOutline
                              : AppIcons.people,
                          size: AppSizes.iconSmall,
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.semiTransparent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Flexible(
                          child: Text(
                            challenge.isPersonal
                                ? 'challenges.personal'.tr()
                                : '${challenge.memberCount} ${tr('challenges.members')}',
                            style: TextStyle(
                              fontSize: AppSizes.fontSmall,
                              color: theme.iconTheme.color?.withValues(
                                alpha: AppOpacity.mostlyOpaque,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing12),
                        Icon(
                          AppIcons.chat,
                          size: AppSizes.iconSmall,
                          color: theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.semiTransparent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Flexible(
                          child: Text(
                            '${challenge.events.length} ${tr('challenges.messages')}',
                            style: TextStyle(
                              fontSize: AppSizes.fontSmall,
                              color: theme.iconTheme.color?.withValues(
                                alpha: AppOpacity.mostlyOpaque,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!_isSelectionMode)
                Icon(
                  AppIcons.chevronRight,
                  color: theme.iconTheme.color?.withValues(
                    alpha: AppOpacity.medium,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Add swipe-to-delete when not in selection mode
    if (!_isSelectionMode) {
      return Dismissible(
        key: Key(challenge.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('challenges.delete'.tr()),
              content: Text('challenges.deleteConfirmation'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('common.cancel'.tr()),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('common.delete'.tr()),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          Provider.of<AppStateProvider>(
            context,
            listen: false,
          ).deleteChallenge(challenge.id);
        },
        background: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSizes.spacing20),
          child: const Icon(
            AppIcons.delete,
            color: Colors.white,
            size: AppSizes.iconMedium,
          ),
        ),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
