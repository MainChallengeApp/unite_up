import 'package:unite_up/enums/event_type_enum.dart';
import 'package:unite_up/models/goal_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';

class EventModel {
  final String id;
  final String challengeId;
  final EventTypeEnum type;
  final DateTime timestamp;

  // User who created this event (null for AI messages)
  final String? userId;

  // For text messages
  final String? message;

  // For progress
  final ProgressEntryModel? progressEntry;

  // For goals
  final GoalModel? goal;
  final String? goalId;

  // For goal updates (stores the old goal state)
  final GoalModel? oldGoal;

  // Track if goal was completed due to this update
  final bool? goalCompletedByUpdate;

  EventModel({
    required this.id,
    required this.challengeId,
    required this.type,
    required this.timestamp,
    this.userId,
    this.message,
    this.progressEntry,
    this.goal,
    this.goalId,
    this.oldGoal,
    this.goalCompletedByUpdate,
  });

  /// Create from database JSON response.
  factory EventModel.fromJson(Map<String, dynamic> json) {
    final goalData = json['goal_data'] as Map<String, dynamic>?;
    final oldGoalData = json['old_goal_data'] as Map<String, dynamic>?;
    final progressData = json['progress_data'] as Map<String, dynamic>?;

    return EventModel(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      type: EventTypeEnum.values.firstWhere(
        (e) => e.name == json['event_type'],
        orElse: () => EventTypeEnum.userMessage,
      ),
      timestamp: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String?,
      message: json['message'] as String?,
      goalId: json['goal_id'] as String?,
      goal: goalData != null ? GoalModel.fromEventJson(goalData) : null,
      oldGoal: oldGoalData != null
          ? GoalModel.fromEventJson(oldGoalData)
          : null,
      goalCompletedByUpdate: json['goal_completed_by_update'] as bool?,
      progressEntry: progressData != null
          ? ProgressEntryModel.fromJson(progressData)
          : null,
    );
  }

  /// Convert to JSON for database insert.
  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'user_id': userId,
      'event_type': type.name,
      'message': message,
      'goal_id': goalId ?? goal?.id,
      'goal_data': goal?.toEventJson(),
      'old_goal_data': oldGoal?.toEventJson(),
      'goal_completed_by_update': goalCompletedByUpdate,
      'progress_data': progressEntry?.toJson(),
    };
  }

  factory EventModel.aiMessage(String challengeId, String message) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: challengeId,
      type: EventTypeEnum.aiMessage,
      timestamp: DateTime.now(),
      message: message,
    );
  }

  factory EventModel.userMessage(
    String challengeId,
    String message, {
    String? userId,
  }) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: challengeId,
      type: EventTypeEnum.userMessage,
      timestamp: DateTime.now(),
      userId: userId,
      message: message,
    );
  }

  factory EventModel.progressSubmitted(
    String challengeId,
    ProgressEntryModel entry, {
    String? userId,
  }) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: challengeId,
      type: EventTypeEnum.progressSubmitted,
      timestamp: DateTime.now(),
      userId: userId,
      progressEntry: entry,
    );
  }

  factory EventModel.goalCreated(GoalModel goal, {String? userId}) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: goal.challengeId,
      type: EventTypeEnum.goalCreated,
      timestamp: DateTime.now(),
      userId: userId,
      goal: goal,
      goalId: goal.id,
    );
  }

  factory EventModel.goalProgressUpdated(GoalModel goal, {String? userId}) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: goal.challengeId,
      type: EventTypeEnum.goalProgressUpdated,
      timestamp: DateTime.now(),
      userId: userId,
      goal: goal,
      goalId: goal.id,
    );
  }

  factory EventModel.goalUpdated(
    GoalModel oldGoal,
    GoalModel newGoal, {
    bool? completedByUpdate,
    String? userId,
  }) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: newGoal.challengeId,
      type: EventTypeEnum.goalUpdated,
      timestamp: DateTime.now(),
      userId: userId,
      goal: newGoal,
      goalId: newGoal.id,
      oldGoal: oldGoal,
      goalCompletedByUpdate: completedByUpdate,
    );
  }

  factory EventModel.goalDeleted(GoalModel goal, {String? userId}) {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: goal.challengeId,
      type: EventTypeEnum.goalDeleted,
      timestamp: DateTime.now(),
      userId: userId,
      goal: goal,
      goalId: goal.id,
    );
  }

  EventModel copyWith({
    String? id,
    String? challengeId,
    EventTypeEnum? type,
    DateTime? timestamp,
    String? userId,
    String? message,
    ProgressEntryModel? progressEntry,
    GoalModel? goal,
    String? goalId,
    GoalModel? oldGoal,
    bool? goalCompletedByUpdate,
  }) {
    return EventModel(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      progressEntry: progressEntry ?? this.progressEntry,
      goal: goal ?? this.goal,
      goalId: goalId ?? this.goalId,
      oldGoal: oldGoal ?? this.oldGoal,
      goalCompletedByUpdate:
          goalCompletedByUpdate ?? this.goalCompletedByUpdate,
    );
  }
}
