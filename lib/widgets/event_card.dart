import 'package:flutter/material.dart';

import '../models/challenge.dart';
import '../models/event.dart';
import 'ai_message_card.dart';
import 'challenge_accepted_card.dart';
import 'challenge_completed_card.dart';
import 'challenges_offered_card.dart';
import 'goal_selected_card.dart';
import 'progress_submitted_card.dart';
import 'user_message_card.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Function(Challenge)? onChallengeAccept;
  final VoidCallback? onSubmitProgress;

  const EventCard({
    super.key,
    required this.event,
    this.onChallengeAccept,
    this.onSubmitProgress,
  });

  @override
  Widget build(BuildContext context) {
    switch (event.type) {
      case EventType.goalSelected:
        return GoalSelectedCard(event: event);
      case EventType.dailyChallengesOffered:
        return ChallengesOfferedCard(
          event: event,
          onChallengeAccept: onChallengeAccept,
        );
      case EventType.challengeAccepted:
        return ChallengeAcceptedCard(
          event: event,
          onSubmitProgress: onSubmitProgress,
        );
      case EventType.progressSubmitted:
        return ProgressSubmittedCard(event: event);
      case EventType.challengeCompleted:
        return ChallengeCompletedCard(event: event);
      case EventType.aiMessage:
        return AIMessageCard(event: event);
      case EventType.userMessage:
        return UserMessageCard(event: event);
    }
  }
}

