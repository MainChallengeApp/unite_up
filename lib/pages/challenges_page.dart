import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/challenge_chat_model.dart';
import 'package:unite_up/pages/chat_page.dart';
import 'package:unite_up/pages/create_challenge_page.dart';
import 'package:unite_up/providers/app_state_provider.dart';
import 'package:unite_up/widgets/custom_app_bar.dart';

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
  final Set<String> _deletingChallengeIds = {};

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.animationEmptyState,
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(
          begin: AppSizes.emptyStateScaleBegin,
          end: AppSizes.emptyStateScaleEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final challenges = appState.challenges;

    return Scaffold(
      appBar: CustomAppBar(
        leading: _buildAppBarLeading(),
        title: _buildAppBarTitle(),
        showBackButton: false,
        actions: _buildAppBarActions(context),
      ),
      body: challenges.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSizes.spacing16,
                    left: AppSizes.spacing16,
                    right: AppSizes.spacing16,
                  ),
                  child: _buildChallengeCard(context, challenges[index]),
                );
              },
            ),
    );
  }

  Widget? _buildAppBarLeading() {
    if (!_isSelectionMode) return null;

    return IconButton(
      icon: const Icon(AppIcons.close),
      onPressed: _exitSelectionMode,
    );
  }

  String _buildAppBarTitle() {
    if (_isSelectionMode) {
      return '${_selectedChallengeIds.length} ${'common.selected'.tr()}';
    }
    return 'challenges.title'.tr();
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
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
    ];
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.spacing32,
          right: AppSizes.spacing32,
          bottom: AppSizes.spacing48,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
                          _theme.colorScheme.primary.withValues(alpha: 0.15),
                          _theme.colorScheme.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.flag,
                      size: 56,
                      color: _theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.spacing32),
            // Title
            Text(
              'challenges.noChallengesYet'.tr(),
              style: AppTextStyles.titleLarge.copyWith(
                color: _theme.brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.darkSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing12),
            // Subtitle
            Text(
              'challenges.emptySubtitle'.tr(),
              style: AppTextStyles.secondaryText(
                context,
                fontSize: AppSizes.fontMedium,
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
                style: AppTextStyles.mediumSemiBold,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _theme.colorScheme.primary,
                foregroundColor: AppColors.white,
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
  ) {
    final isSelected = _selectedChallengeIds.contains(challenge.id);
    final isDeleting = _deletingChallengeIds.contains(challenge.id);

    final cardContent = Card(
      margin: EdgeInsets.zero,
      elevation: AppSizes.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: BorderSide(
          color: isSelected
              ? _theme.colorScheme.primary
              : _theme.dividerColor.withValues(alpha: AppOpacity.subtle),
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
                  color: _theme.colorScheme.primary.withValues(
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
                      challenge.name,
                      style: AppTextStyles.largeSemiBoldPrimary(context),
                    ),
                    if (challenge.description != null &&
                        challenge.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSizes.spacing4),
                      Text(
                        challenge.description!,
                        style: AppTextStyles.regularSecondary(context),
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
                          color: _theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.semiTransparent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Flexible(
                          child: Text(
                            challenge.isPersonal
                                ? 'challenges.personal'.tr()
                                : '${challenge.memberCount} ${tr('challenges.members')}',
                            style: AppTextStyles.smallSecondary(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing12),
                        Icon(
                          AppIcons.chat,
                          size: AppSizes.iconSmall,
                          color: _theme.iconTheme.color?.withValues(
                            alpha: AppOpacity.semiTransparent,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing4),
                        Flexible(
                          child: Text(
                            '${challenge.events.length} ${tr('challenges.messages')}',
                            style: AppTextStyles.smallSecondary(context),
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
                  color: _theme.iconTheme.color?.withValues(
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
      return AnimatedSlide(
        offset: isDeleting
            ? AppSizes.slideOffsetLeft
            : AppSizes.slideOffsetZero,
        duration: AppDurations.animationNormal,
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: isDeleting ? 0.0 : 1.0,
          duration: AppDurations.animationNormal,
          child: Slidable(
            key: Key(challenge.id),
            closeOnScroll: true,
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: AppSizes.slidableExtentRatio,
              dragDismissible: false,
              dismissible: DismissiblePane(
                closeOnCancel: true,
                onDismissed: () {
                  HapticFeedback.mediumImpact();
                  final appState = Provider.of<AppStateProvider>(
                    context,
                    listen: false,
                  );
                  appState.deleteChallenge(challenge.id);
                },
                confirmDismiss: () async {
                  HapticFeedback.lightImpact();
                  if (!mounted) return false;

                  final confirmed = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => AlertDialog(
                      title: Text('challenges.delete'.tr()),
                      content: Text('challenges.deleteConfirmation'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text('common.cancel'.tr()),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.red,
                          ),
                          child: Text('common.delete'.tr()),
                        ),
                      ],
                    ),
                  );
                  return confirmed ?? false;
                },
              ),
              children: [
                CustomSlidableAction(
                  onPressed: (context) async {
                    HapticFeedback.lightImpact();
                    if (!mounted) return;

                    final confirmed = await showDialog<bool>(
                      context: this.context,
                      barrierDismissible: false,
                      builder: (dialogContext) => AlertDialog(
                        title: Text('challenges.delete'.tr()),
                        content: Text('challenges.deleteConfirmation'.tr()),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text('common.cancel'.tr()),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.red,
                            ),
                            child: Text('common.delete'.tr()),
                          ),
                        ],
                      ),
                    );

                    if (!mounted) return;

                    if (confirmed == true) {
                      HapticFeedback.mediumImpact();
                      // Mark as deleting to trigger slide animation
                      setState(() {
                        _deletingChallengeIds.add(challenge.id);
                      });
                      // Wait for animation to complete
                      await Future.delayed(AppDurations.animationNormal);
                      // Then delete
                      if (mounted) {
                        Provider.of<AppStateProvider>(
                          this.context,
                          listen: false,
                        ).deleteChallenge(challenge.id);
                        setState(() {
                          _deletingChallengeIds.remove(challenge.id);
                        });
                      }
                    }
                  },
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spacing16,
                    0,
                    0,
                    0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    ),
                    child: const Center(
                      child: Icon(
                        AppIcons.delete,
                        color: AppColors.white,
                        size: AppSizes.iconMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: cardContent,
          ),
        ),
      );
    }

    return AnimatedSlide(
      offset: isDeleting ? AppSizes.slideOffsetLeft : AppSizes.slideOffsetZero,
      duration: AppDurations.animationNormal,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isDeleting ? 0.0 : 1.0,
        duration: AppDurations.animationNormal,
        child: cardContent,
      ),
    );
  }
}
