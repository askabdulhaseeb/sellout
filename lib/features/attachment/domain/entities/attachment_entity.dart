import 'package:hive_ce/hive.dart';

import '../../../../core/enums/core/attachment_type.dart';
export '../../../../core/enums/core/attachment_type.dart';

part 'attachment_entity.g.dart';

@HiveType(typeId: 4)
class AttachmentEntity {
  const AttachmentEntity({
    required this.createdAt,
    required this.type,
    required this.url,
    required this.originalName,
    required this.fileId,
  });

  @HiveField(0)
  final DateTime createdAt;
  @HiveField(1)
  final AttachmentType type;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String originalName;
  @HiveField(4)
  final String fileId;
}
