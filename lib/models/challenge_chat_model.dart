import 'package:unite_up/enums/goal_category_enum.dart';
import 'package:unite_up/models/event_model.dart';
import 'package:unite_up/models/goal_model.dart';

class ChallengeChatModel {
  final String id;
  final String name;
  final String? description;
  final GoalCategoryEnum category;
  final String emoji;
  final List<String> memberIds;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<EventModel> events;
  final List<GoalModel> goals;

  ChallengeChatModel({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.emoji,
    required this.memberIds,
    required this.creatorId,
    required this.createdAt,
    DateTime? updatedAt,
    this.events = const [],
    this.goals = const [],
  }) : updatedAt = updatedAt ?? createdAt;

  // Helper getters
  bool get isPersonal => memberIds.length == 1;
  bool get isGroup => memberIds.length > 1;
  int get memberCount => memberIds.length;

  /// Create from database JSON response.
  /// [memberIds] should be passed separately from challenge_members query.
  factory ChallengeChatModel.fromJson(
    Map<String, dynamic> json, {
    List<String>? memberIds,
    List<GoalModel>? goals,
    List<EventModel>? events,
  }) {
    return ChallengeChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: GoalCategoryEnum.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => GoalCategoryEnum.custom,
      ),
      emoji: json['emoji'] as String? ?? '🎯',
      memberIds: memberIds ?? [json['creator_id'] as String],
      creatorId: json['creator_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      goals: goals ?? const [],
      events: events ?? const [],
    );
  }

  /// Convert to JSON for database insert/update.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category.name,
      'emoji': emoji,
      'creator_id': creatorId,
      'is_personal': isPersonal,
    };
  }

  /// Convert to JSON for database update (excludes immutable fields).
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'description': description,
      'category': category.name,
      'emoji': emoji,
    };
  }

  ChallengeChatModel copyWith({
    String? id,
    String? name,
    String? description,
    GoalCategoryEnum? category,
    String? emoji,
    List<String>? memberIds,
    String? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<EventModel>? events,
    List<GoalModel>? goals,
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
      updatedAt: updatedAt ?? this.updatedAt,
      events: events ?? this.events,
      goals: goals ?? this.goals,
    );
  }
}
