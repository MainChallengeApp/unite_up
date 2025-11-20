import 'package:dare_u/models/challenge.dart';
import 'package:dare_u/models/event_type.dart';
import 'package:dare_u/models/goal.dart';
import 'package:dare_u/models/progress_entry.dart';

class Event {
  final String id;
  final EventType type;
  final DateTime timestamp;

  // For text messages
  final String? message;

  // For goal selection
  final Goal? goal;

  // For challenges
  final List<Challenge>? challenges;
  final Challenge? selectedChallenge;

  // For progress
  final ProgressEntry? progressEntry;

  Event({
    required this.id,
    required this.type,
    required this.timestamp,
    this.message,
    this.goal,
    this.challenges,
    this.selectedChallenge,
    this.progressEntry,
  });

  factory Event.goalSelected(Goal goal) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.goalSelected,
      timestamp: DateTime.now(),
      goal: goal,
    );
  }

  factory Event.dailyChallengesOffered(List<Challenge> challenges) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.dailyChallengesOffered,
      timestamp: DateTime.now(),
      challenges: challenges,
    );
  }

  factory Event.challengeAccepted(Challenge challenge) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.challengeAccepted,
      timestamp: DateTime.now(),
      selectedChallenge: challenge,
    );
  }

  factory Event.progressSubmitted(ProgressEntry entry) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.progressSubmitted,
      timestamp: DateTime.now(),
      progressEntry: entry,
    );
  }

  factory Event.challengeCompleted(Challenge challenge) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.challengeCompleted,
      timestamp: DateTime.now(),
      selectedChallenge: challenge,
    );
  }

  factory Event.aiMessage(String message) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.aiMessage,
      timestamp: DateTime.now(),
      message: message,
    );
  }

  factory Event.userMessage(String message) {
    return Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventType.userMessage,
      timestamp: DateTime.now(),
      message: message,
    );
  }
}
