import 'package:flutter/material.dart';

import 'package:dare_u/enums/event_type_enum.dart';
import 'package:dare_u/models/event_model.dart';
import 'package:dare_u/widgets/ai_message_card.dart';
import 'package:dare_u/widgets/progress_submitted_card.dart';
import 'package:dare_u/widgets/user_message_card.dart';

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
    }
  }
}
