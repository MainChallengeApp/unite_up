import 'package:unite_up/enums/goal_category_enum.dart';
import 'package:unite_up/models/event_model.dart';

class ChallengeChatModel {
  final String id;
  final String name;
  final String? description;
  final GoalCategoryEnum category;
  final String emoji;
  final List<String> memberIds;
  final String creatorId;
  final DateTime createdAt;
  final List<EventModel> events;

  ChallengeChatModel({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.emoji,
    required this.memberIds,
    required this.creatorId,
    required this.createdAt,
    this.events = const [],
  });

  // Helper getters
  bool get isPersonal => memberIds.length == 1;
  bool get isGroup => memberIds.length > 1;
  int get memberCount => memberIds.length;

  ChallengeChatModel copyWith({
    String? id,
    String? name,
    String? description,
    GoalCategoryEnum? category,
    String? emoji,
    List<String>? memberIds,
    String? creatorId,
    DateTime? createdAt,
    List<EventModel>? events,
  }) {
    return ChallengeChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      memberIds: memberIds ?? this.memberIds,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      events: events ?? this.events,
    );
  }
}

