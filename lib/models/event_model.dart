import 'package:dare_u/enums/event_type_enum.dart';
import 'package:dare_u/models/challenge_model.dart';
import 'package:dare_u/models/goal_model.dart';
import 'package:dare_u/models/progress_entry_model.dart';

class EventModel {
  final String id;
  final EventTypeEnum type;
  final DateTime timestamp;

  // For text messages
  final String? message;

  // For goal selection
  final GoalModel? goal;

  // For challenges
  final List<ChallengeModel>? challenges;
  final ChallengeModel? selectedChallenge;

  // For progress
  final ProgressEntryModel? progressEntry;

  EventModel({
    required this.id,
    required this.type,
    required this.timestamp,
    this.message,
    this.goal,
    this.challenges,
    this.selectedChallenge,
    this.progressEntry,
  });

  factory EventModel.goalSelected(GoalModel goal) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.goalSelected,
      timestamp: DateTime.now(),
      goal: goal,
    );
  }

  factory EventModel.dailyChallengesOffered(List<ChallengeModel> challenges) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.dailyChallengesOffered,
      timestamp: DateTime.now(),
      challenges: challenges,
    );
  }

  factory EventModel.challengeAccepted(ChallengeModel challenge) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.challengeAccepted,
      timestamp: DateTime.now(),
      selectedChallenge: challenge,
    );
  }

  factory EventModel.progressSubmitted(ProgressEntryModel entry) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.progressSubmitted,
      timestamp: DateTime.now(),
      progressEntry: entry,
    );
  }

  factory EventModel.challengeCompleted(ChallengeModel challenge) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.challengeCompleted,
      timestamp: DateTime.now(),
      selectedChallenge: challenge,
    );
  }

  factory EventModel.aiMessage(String message) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.aiMessage,
      timestamp: DateTime.now(),
      message: message,
    );
  }

  factory EventModel.userMessage(String message) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.userMessage,
      timestamp: DateTime.now(),
      message: message,
    );
  }
}

