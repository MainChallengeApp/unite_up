import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
        title: Text(
          'challenges.title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontXLarge,
          ),
        ),
        actions: [
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
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      elevation: AppSizes.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: AppOpacity.subtle),
          width: AppSizes.borderThin,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToChallengeChat(context, challenge.id),
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
                child: Center(
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
                        Text(
                          challenge.isPersonal
                              ? 'challenges.personal'.tr()
                              : 'challenges.member'.tr(
                                  namedArgs: {
                                    'count': challenge.memberCount.toString(),
                                  },
                                ),
                          style: TextStyle(
                            fontSize: AppSizes.fontSmall,
                            color: theme.iconTheme.color?.withValues(
                              alpha: AppOpacity.mostlyOpaque,
                            ),
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
                        Text(
                          '${challenge.events.length} ${'challenges.messages'.tr()}',
                          style: TextStyle(
                            fontSize: AppSizes.fontSmall,
                            color: theme.iconTheme.color?.withValues(
                              alpha: AppOpacity.mostlyOpaque,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
  }
}
