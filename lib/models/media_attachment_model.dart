import 'package:dare_u/enums/media_type_enum.dart';

class MediaAttachmentModel {
  final String id;
  final MediaTypeEnum type;
  final String path;
  final String? fileName;
  final DateTime uploadedAt;

  MediaAttachmentModel({
    required this.id,
    required this.type,
    required this.path,
    this.fileName,
    required this.uploadedAt,
  });
}

