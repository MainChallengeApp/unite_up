import 'package:dare_u/models/media_type.dart';

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

