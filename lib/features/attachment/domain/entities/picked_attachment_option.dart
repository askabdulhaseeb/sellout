import 'package:photo_manager/photo_manager.dart';

import '../../../../core/enums/core/attachment_type.dart';


class PickableAttachmentOption {
  PickableAttachmentOption({
    this.maxAttachments = 10,
    this.allowMultiple = true,
    this.type = AttachmentType.video,
    this.maxVideoDuration = const Duration(minutes: 2),
    this.selectedMedia,
  });

  final int maxAttachments;
  final bool allowMultiple;
  final AttachmentType type;
  final Duration maxVideoDuration;
  final List<AssetEntity>? selectedMedia;
}
