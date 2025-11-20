import 'package:flutter/material.dart';

import 'package:dare_u/enums/event_type_enum.dart';
import 'package:dare_u/models/challenge_model.dart';
import 'package:dare_u/models/event_model.dart';
import 'package:dare_u/widgets/ai_message_card.dart';
import 'challenge_accepted_card.dart';
import 'challenge_completed_card.dart';
import 'challenges_offered_card.dart';
import 'goal_selected_card.dart';
import 'progress_submitted_card.dart';
import 'user_message_card.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final Function(ChallengeModel)? onChallengeAccept;
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
      case EventTypeEnum.goalSelected:
        return GoalSelectedCard(event: event);
      case EventTypeEnum.dailyChallengesOffered:
        return ChallengesOfferedCard(
          event: event,
          onChallengeAccept: onChallengeAccept,
        );
      case EventTypeEnum.challengeAccepted:
        return ChallengeAcceptedCard(
          event: event,
          onSubmitProgress: onSubmitProgress,
        );
      case EventTypeEnum.progressSubmitted:
        return ProgressSubmittedCard(event: event);
      case EventTypeEnum.challengeCompleted:
        return ChallengeCompletedCard(event: event);
      case EventTypeEnum.aiMessage:
        return AIMessageCard(event: event);
      case EventTypeEnum.userMessage:
        return UserMessageCard(event: event);
    }
  }
}

