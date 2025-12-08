class GoalModel {
  final String id;
  final String challengeId;
  final String userId;
  final String title;
  final double startValue;
  final double endValue;
  final double currentValue;
  final DateTime startDate;
  final DateTime endDate;
  final String? unit; // e.g., "kg", "km", "hours", etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  GoalModel({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.title,
    required this.startValue,
    required this.endValue,
    required this.currentValue,
    required this.startDate,
    required this.endDate,
    this.unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create from database JSON response.
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      startValue: (json['start_value'] as num).toDouble(),
      endValue: (json['end_value'] as num).toDouble(),
      currentValue: (json['current_value'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      unit: json['unit'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for database insert.
  Map<String, dynamic> toJson() {
    return {
      'challenge_id': challengeId,
      'user_id': userId,
      'title': title,
      'start_value': startValue,
      'end_value': endValue,
      'current_value': currentValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'unit': unit,
    };
  }

  /// Convert to JSON for storing in event history.
  Map<String, dynamic> toEventJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'user_id': userId,
      'title': title,
      'start_value': startValue,
      'end_value': endValue,
      'current_value': currentValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'unit': unit,
    };
  }

  /// Create from event JSON (stored in challenge_events).
  factory GoalModel.fromEventJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      startValue: (json['start_value'] as num).toDouble(),
      endValue: (json['end_value'] as num).toDouble(),
      currentValue: (json['current_value'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      unit: json['unit'] as String?,
    );
  }

  // Calculate progress percentage (works for both increasing and decreasing goals)
  double get progressPercentage {
    final range = endValue - startValue;
    if (range == 0) return 0;

    final progress = currentValue - startValue;
    final percentage = (progress / range) * 100;
    return percentage.clamp(0, 100);
  }

  // Check if goal is completed (works for both increasing and decreasing goals)
  bool get isCompleted {
    if (endValue > startValue) {
      // Increasing goal (e.g., run 100km)
      return currentValue >= endValue;
    } else {
      // Decreasing goal (e.g., lose 10kg)
      return currentValue <= endValue;
    }
  }

  // Check if goal is overdue
  bool get isOverdue {
    return DateTime.now().isAfter(endDate) && !isCompleted;
  }

  // Days remaining
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  GoalModel copyWith({
    String? id,
    String? challengeId,
    String? userId,
    String? title,
    double? startValue,
    double? endValue,
    double? currentValue,
    DateTime? startDate,
    DateTime? endDate,
    String? unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startValue: startValue ?? this.startValue,
      endValue: endValue ?? this.endValue,
      currentValue: currentValue ?? this.currentValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
