import 'package:unite_up/enums/media_type_enum.dart';

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

  /// Create from JSON.
  factory MediaAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MediaAttachmentModel(
      id: json['id'] as String,
      type: MediaTypeEnum.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaTypeEnum.image,
      ),
      path: json['path'] as String,
      fileName: json['file_name'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'path': path,
      'file_name': fileName,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
