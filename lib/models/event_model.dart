import 'package:unite_up/enums/event_type_enum.dart';
import 'package:unite_up/models/progress_entry_model.dart';

class EventModel {
  final String id;
  final EventTypeEnum type;
  final DateTime timestamp;

  // For text messages
  final String? message;

  // For progress
  final ProgressEntryModel? progressEntry;

  EventModel({
    required this.id,
    required this.type,
    required this.timestamp,
    this.message,
    this.progressEntry,
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

  EventModel copyWith({
    String? id,
    EventTypeEnum? type,
    DateTime? timestamp,
    String? message,
    ProgressEntryModel? progressEntry,
  }) {
    return EventModel(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      message: message ?? this.message,
      progressEntry: progressEntry ?? this.progressEntry,
    );
  }
}
