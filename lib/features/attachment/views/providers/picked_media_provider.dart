import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/functions/app_log.dart';
import '../../domain/entities/picked_attachment.dart';
import '../../domain/entities/picked_attachment_option.dart';

class PickedMediaProvider extends ChangeNotifier {
  Future<void> onSubmit(BuildContext context) async {
    final List<PickedAttachment> attachmentss = <PickedAttachment>[];
    try {
      for (final AssetEntity media in _pickedMedia) {
        final File? file = await media.file;
        if (file == null) continue;
        final AttachmentType type = media.type == AssetType.image
            ? AttachmentType.image
            : AttachmentType.video;
        final PickedAttachment attachment = PickedAttachment(
          file: file,
          type: type,
          selectedMedia: media,
        );
        if (!(_option.selectedMedia ?? <AssetEntity>[])
            .any((AssetEntity e) => e.id == media.id)) {
          attachmentss.add(attachment);
        }
      }
    } catch (e) {
      AppLog.error(
        'Error submitting picked media',
        name: 'PickedMediaProvider.onSubmit',
        error: e,
      );
    }
    clearMedia();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(attachmentss);
  }

  // Setters

  void setOption(BuildContext context, PickableAttachmentOption value) {
    _option = value;
    _pickedMedia.addAll(value.selectedMedia ?? <AssetEntity>[]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addMedia(AssetEntity value) {
    _pickedMedia.add(value);
    notifyListeners();
  }

  void removeMedia(int value) {
    _pickedMedia.removeAt(value);
    notifyListeners();
  }
  void onTap(AssetEntity? value) {
    if (value == null) return;
    if (_pickedMedia.length > _option.maxAttachments) return;
final bool isOld = _option.selectedMedia?.any((AssetEntity e) => e.id == value.id) ?? false;
    final int existingIndex = _pickedMedia.indexWhere((AssetEntity e) => e.id == value.id);
if (existingIndex != -1 && !isOld) {
  removeMedia(existingIndex);
} else if (existingIndex == -1 && !isOld) {
  addMedia(value);
}
  }

  int? indexOf(AssetEntity value) {
final int index = _pickedMedia.indexWhere((AssetEntity e) => e.id == value.id);
    return index == -1 ? null : index;
  }

  void clearMedia() {
    _pickedMedia.clear();
    notifyListeners();
  } 

  // Getters
  List<AssetEntity> get pickedMedia => _pickedMedia;
  PickableAttachmentOption get option => _option;
  String get selectionStr => '${_pickedMedia.length}/${_option.maxAttachments}';

  // Controllers
  final List<AssetEntity> _pickedMedia = <AssetEntity>[];
  PickableAttachmentOption _option = PickableAttachmentOption();
}
