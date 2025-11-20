import 'package:flutter/material.dart';

import 'package:dare_u/enums/challenge_status_enum.dart';
import 'package:dare_u/models/challenge_model.dart';
import 'package:dare_u/models/event_model.dart';

class ChallengesOfferedCard extends StatelessWidget {
  final EventModel event;
  final Function(ChallengeModel)? onChallengeAccept;

  const ChallengesOfferedCard({
    super.key,
    required this.event,
    this.onChallengeAccept,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challenges = event.challenges!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              '✨ Today\'s ChallengeModels - Pick One',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.iconTheme.color?.withOpacity(0.7),
              ),
            ),
          ),
          ...challenges.map(
            (challenge) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildChallengeModelCard(context, challenge, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeModelCard(
    BuildContext context,
    ChallengeModel challenge,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: challenge.status == ChallengeStatusEnum.available
            ? () => onChallengeAccept?.call(challenge)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: challenge.difficulty.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          challenge.difficulty.emoji,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge.difficulty.displayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: challenge.difficulty.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                challenge.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.iconTheme.color?.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              if (challenge.status == ChallengeStatusEnum.available) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap to accept',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

}

