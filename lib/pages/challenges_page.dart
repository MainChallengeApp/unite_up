import 'package:dare_u/models/challenge_chat_model.dart';
import 'package:dare_u/pages/chat_page.dart';
import 'package:dare_u/pages/create_challenge_page.dart';
import 'package:dare_u/providers/app_state_provider.dart';
import 'package:dare_u/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
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
        title: const Text(
          'Challenges',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _createNewChallenge(context),
            tooltip: 'Create Challenge',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: challenges.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return _buildChallengeCard(context, challenges[index], theme);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return EmptyState(
      icon: Icons.flag_outlined,
      title: 'No challenges yet',
      subtitle: 'Create your first challenge to start your journey!',
      buttonText: 'Create Challenge',
      onButtonPressed: () => _createNewChallenge(context),
    );
  }

  Widget _buildChallengeCard(
    BuildContext context,
    ChallengeChatModel challenge,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () => _navigateToChallengeChat(context, challenge.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    challenge.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (challenge.description != null) ...[
                      Text(
                        challenge.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.iconTheme.color?.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        Icon(
                          challenge.isPersonal
                              ? Icons.person_outline_rounded
                              : Icons.people_outline_rounded,
                          size: 16,
                          color: theme.iconTheme.color?.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge.isPersonal
                              ? 'Personal'
                              : '${challenge.memberCount} members',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.iconTheme.color?.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: theme.iconTheme.color?.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.events.length} messages',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.iconTheme.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.iconTheme.color?.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
