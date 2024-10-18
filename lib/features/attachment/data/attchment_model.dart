import '../domain/entities/attachment_entity.dart';

class AttachmentModel extends AttachmentEntity {
  AttachmentModel({
    required super.createdAt,
    required super.type,
    required super.url,
    required super.fileId,
    required super.originalName,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      AttachmentModel(
        createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
        type: AttachmentType.fromString(json['type']),
        url: json['url'] ?? '',
        fileId: json['file_id'] ?? '',
        originalName: json['original_name'] ?? '',
      );
}
