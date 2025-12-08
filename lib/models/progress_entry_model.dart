import 'package:unite_up/models/media_attachment_model.dart';

class ProgressEntryModel {
  final String id;
  final String challengeId;
  final String note;
  final List<MediaAttachmentModel> attachments;
  final DateTime createdAt;

  ProgressEntryModel({
    required this.id,
    required this.challengeId,
    required this.note,
    required this.attachments,
    required this.createdAt,
  });

  /// Create from JSON (stored in challenge_events.progress_data).
  factory ProgressEntryModel.fromJson(Map<String, dynamic> json) {
    return ProgressEntryModel(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      note: json['note'] as String,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map(
                (a) => MediaAttachmentModel.fromJson(a as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert to JSON for storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'note': note,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
