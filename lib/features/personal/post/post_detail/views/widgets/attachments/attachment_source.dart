import 'dart:io';
import '../../../../../../attachment/domain/entities/attachment_entity.dart'
    as remote;
import '../../../../../../attachment/domain/entities/picked_attachment.dart'
    as picked;
import '../../../../../../../core/enums/core/attachment_type.dart';

/// A unified model for attachments coming from either remote [AttachmentEntity]
/// or locally [PickedAttachment].
class AttachmentSource {
  factory AttachmentSource.fromPickedAttachment(picked.PickedAttachment p) {
    return AttachmentSource._(
      isVideo: p.type == AttachmentType.video,
      filePath: p.file.path,
    );
  }

  factory AttachmentSource.fromAttachmentEntity(remote.AttachmentEntity a) {
    return AttachmentSource._(
      isVideo: a.type == AttachmentType.video,
      networkUrl: a.url,
    );
  }
  AttachmentSource._({
    required this.isVideo,
    this.networkUrl,
    this.filePath,
  });

  /// True if this source is a video, false if image.
  final bool isVideo;

  /// Network URL for image/video.
  final String? networkUrl;

  /// Local file path for image/video.
  final String? filePath;

  bool get isNetwork => (networkUrl != null && networkUrl!.isNotEmpty);
  bool get isLocal => (filePath != null && filePath!.isNotEmpty);
  File? get file => isLocal ? File(filePath!) : null;
}
