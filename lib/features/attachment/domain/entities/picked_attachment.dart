import 'package:photo_manager/photo_manager.dart';
import 'attachment_entity.dart';
export '../../../../core/enums/core/attachment_type.dart';
class PickedAttachment {
  const PickedAttachment({
    required this.file,
    required this.type,
    this.selectedMedia,
  });

  final dynamic file;
  final AttachmentType type;
  final AssetEntity? selectedMedia;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickedAttachment &&
          runtimeType == other.runtimeType &&
          selectedMedia?.id == other.selectedMedia?.id;

  @override
  int get hashCode => selectedMedia?.id.hashCode ?? 0;
}
