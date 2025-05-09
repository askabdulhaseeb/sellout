import '../../../core/extension/string_ext.dart';
import '../domain/entities/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  AttachmentModel({
    required super.createdAt,
    required super.type,
    required super.url,
    required super.fileId,
    required super.originalName,
  });

  factory AttachmentModel.fromEntity(AttachmentEntity entity) =>
      AttachmentModel(
        createdAt: entity.createdAt,
        type: entity.type,
        url: entity.url,
        fileId: entity.fileId,
        originalName: entity.originalName,
      );

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      AttachmentModel(
        createdAt:
            (json['created_at']?.toString().toDateTime()) ?? DateTime.now(),
        type: AttachmentType.fromString(json['type']),
        url: json['url'] ?? '',
        fileId: json['file_id'] ?? '',
        originalName: json['original_name'] ?? '',
      );
      
  Map<String, dynamic> toJson() => <String, String>{
        'created_at': createdAt.toUtc().toIso8601String(),
        'type': type.json.toString(),
        'url': url,
        'file_id': _cleanFileId(fileId),
        'original_name': originalName,
      };
}

String _cleanFileId(String id) {
  final List<String> parts = id.split('/');
  return parts.last;
}
