class GoalModel {
  final String id;
  final String userId;
  final String title;
  final double startValue;
  final double endValue;
  final double currentValue;
  final DateTime startDate;
  final DateTime endDate;
  final String? unit; // e.g., "kg", "km", "hours", etc.

  GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.startValue,
    required this.endValue,
    required this.currentValue,
    required this.startDate,
    required this.endDate,
    this.unit,
  });

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
    String? userId,
    String? title,
    double? startValue,
    double? endValue,
    double? currentValue,
    DateTime? startDate,
    DateTime? endDate,
    String? unit,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startValue: startValue ?? this.startValue,
      endValue: endValue ?? this.endValue,
      currentValue: currentValue ?? this.currentValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      unit: unit ?? this.unit,
    );
  }
}
