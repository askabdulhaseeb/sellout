import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'attachment_entity.dart';
export '../../../../core/enums/core/attachment_type.dart';

class PickedAttachment {
  const PickedAttachment({
    required this.file,
    required this.type,
    this.selectedMedia,
  });

  final File file;
  final AttachmentType type;
  final AssetEntity? selectedMedia;
}
