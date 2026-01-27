import 'package:flutter/material.dart';
import 'package:unite_up/core/constants/app_colors.dart';
import 'package:unite_up/core/constants/app_icons.dart';

enum NotificationType {
  follow,
  challengeInvite,
  goalCompleted,
  progressUpdate,
  system;

  String toJson() {
    switch (this) {
      case NotificationType.follow:
        return 'follow';
      case NotificationType.challengeInvite:
        return 'challenge_invite';
      case NotificationType.goalCompleted:
        return 'goal_completed';
      case NotificationType.progressUpdate:
        return 'progress_update';
      case NotificationType.system:
        return 'system';
    }
  }

  static NotificationType fromJson(String json) {
    switch (json) {
      case 'follow':
        return NotificationType.follow;
      case 'challenge_invite':
        return NotificationType.challengeInvite;
      case 'goal_completed':
        return NotificationType.goalCompleted;
      case 'progress_update':
        return NotificationType.progressUpdate;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }
}

class NotificationItemModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? actionUserId;
  final String? actionUserName;
  final String? challengeId;

  const NotificationItemModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.actionUserId,
    this.actionUserName,
    this.challengeId,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    // Handle joined user data for action_user_name
    String? actionUserName;
    if (json['action_user'] != null && json['action_user'] is Map) {
      actionUserName = json['action_user']['display_name'] as String?;
    }

    return NotificationItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: NotificationType.fromJson(json['type'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      actionUserId: json['action_user_id'] as String?,
      actionUserName: actionUserName,
      challengeId: json['challenge_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toJson(),
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'action_user_id': actionUserId,
      'challenge_id': challengeId,
    };
  }

  NotificationItemModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? actionUserId,
    String? actionUserName,
    String? challengeId,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionUserId: actionUserId ?? this.actionUserId,
      actionUserName: actionUserName ?? this.actionUserName,
      challengeId: challengeId ?? this.challengeId,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.follow:
        return AppIcons.personAdd;
      case NotificationType.challengeInvite:
        return AppIcons.mailOutline;
      case NotificationType.goalCompleted:
        return AppIcons.trophy;
      case NotificationType.progressUpdate:
        return AppIcons.trendingUp;
      case NotificationType.system:
        return AppIcons.notifications;
    }
  }

  Color getIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case NotificationType.follow:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case NotificationType.challengeInvite:
        return isDark ? AppColors.darkEmerald : AppColors.lightEmerald;
      case NotificationType.goalCompleted:
        return isDark ? AppColors.darkAmber : AppColors.lightAmber;
      case NotificationType.progressUpdate:
        return isDark ? AppColors.darkSky : AppColors.lightSky;
      case NotificationType.system:
        return isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
    }
  }
}
