import 'package:flutter/material.dart';

import 'package:unite_up/enums/event_type_enum.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/widgets/ai_message_card.dart';
import 'package:unite_up/widgets/goal_created_card.dart';
import 'package:unite_up/widgets/goal_progress_updated_card.dart';
import 'package:unite_up/widgets/progress_submitted_card.dart';
import 'package:unite_up/widgets/user_message_card.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final Function? onChallengeAccept;
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
      case EventTypeEnum.progressSubmitted:
        return ProgressSubmittedCard(event: event);
      case EventTypeEnum.aiMessage:
        return AIMessageCard(event: event);
      case EventTypeEnum.userMessage:
        return UserMessageCard(event: event);
      case EventTypeEnum.goalCreated:
        return GoalCreatedCard(event: event);
      case EventTypeEnum.goalProgressUpdated:
        return GoalProgressUpdatedCard(event: event);
    }
  }
}
