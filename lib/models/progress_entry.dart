import 'package:dare_u/models/media_attachment.dart';

class ProgressEntry {
  final String id;
  final String challengeId;
  final String note;
  final List<MediaAttachment> attachments;
  final DateTime createdAt;

  ProgressEntry({
    required this.id,
    required this.challengeId,
    required this.note,
    required this.attachments,
    required this.createdAt,
  });
}
