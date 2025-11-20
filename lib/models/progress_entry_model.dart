import 'package:dare_u/models/media_attachment_model.dart';

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
}

