import 'package:unite_up/enums/event_type_enum.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';

class EventModel {
  final String id;
  final EventTypeEnum type;
  final DateTime timestamp;

  // For text messages
  final String? message;

  // For progress
  final ProgressEntryModel? progressEntry;

  // For goals
  final GoalModel? goal;

  // For goal updates (stores the old goal state)
  final GoalModel? oldGoal;

  // Track if goal was completed due to this update
  final bool? goalCompletedByUpdate;

  EventModel({
    required this.id,
    required this.type,
    required this.timestamp,
    this.message,
    this.progressEntry,
    this.goal,
    this.oldGoal,
    this.goalCompletedByUpdate,
  });

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

  factory EventModel.progressSubmitted(ProgressEntryModel entry) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.progressSubmitted,
      timestamp: DateTime.now(),
      progressEntry: entry,
    );
  }

  factory EventModel.goalCreated(GoalModel goal) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.goalCreated,
      timestamp: DateTime.now(),
      goal: goal,
    );
  }

  factory EventModel.goalProgressUpdated(GoalModel goal) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.goalProgressUpdated,
      timestamp: DateTime.now(),
      goal: goal,
    );
  }

  factory EventModel.goalUpdated(
    GoalModel oldGoal,
    GoalModel newGoal, {
    bool? completedByUpdate,
  }) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.goalUpdated,
      timestamp: DateTime.now(),
      goal: newGoal,
      oldGoal: oldGoal,
      goalCompletedByUpdate: completedByUpdate,
    );
  }

  factory EventModel.goalDeleted(GoalModel goal) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: EventTypeEnum.goalDeleted,
      timestamp: DateTime.now(),
      goal: goal,
    );
  }

  EventModel copyWith({
    String? id,
    EventTypeEnum? type,
    DateTime? timestamp,
    String? message,
    ProgressEntryModel? progressEntry,
    GoalModel? goal,
    GoalModel? oldGoal,
    bool? goalCompletedByUpdate,
  }) {
    return EventModel(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      message: message ?? this.message,
      progressEntry: progressEntry ?? this.progressEntry,
      goal: goal ?? this.goal,
      oldGoal: oldGoal ?? this.oldGoal,
      goalCompletedByUpdate:
          goalCompletedByUpdate ?? this.goalCompletedByUpdate,
    );
  }
}
