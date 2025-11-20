enum MediaType {
  image,
  video,
  file;
}

class MediaAttachment {
  final String id;
  final MediaType type;
  final String path;
  final String? fileName;
  final DateTime uploadedAt;

  MediaAttachment({
    required this.id,
    required this.type,
    required this.path,
    this.fileName,
    required this.uploadedAt,
  });
}

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

