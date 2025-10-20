import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../../../attachment/views/screens/pickable_attachment_screen.dart';

/// Encapsulates all attachment selection and counting logic.
class AttachmentManager {
  final List<PickedAttachment> _attachments = <PickedAttachment>[];

  List<PickedAttachment> get items => List.unmodifiable(_attachments);

  void add(PickedAttachment attachment) {
    _attachments.add(attachment);
  }

  void remove(PickedAttachment attachment) {
    _attachments.remove(attachment);
  }

  void clear() {
    _attachments.clear();
  }

  /// Picks images/videos and updates the internal list, avoiding duplicates.
  Future<void> pick(
    BuildContext context, {
    required AttachmentType type,
    required ListingType listingType,
  }) async {
    final int maxAttachments = switch (type) {
      AttachmentType.image => listingType == ListingType.property
          ? 30
          : listingType == ListingType.vehicle
              ? 20
              : 10,
      AttachmentType.video => 1,
      _ => 10,
    };

    final List<AssetEntity> selectedMedia = _attachments
        .where(
            (PickedAttachment e) => e.selectedMedia != null && e.type == type)
        .map((PickedAttachment e) => e.selectedMedia!)
        .toList();

    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxVideoDuration: const Duration(minutes: 5),
            maxAttachments: maxAttachments,
            allowMultiple: true,
            type: type,
            selectedMedia: selectedMedia,
          ),
        );
      }),
    );

    if (files == null) return;

    for (final PickedAttachment file in files) {
      final int index = _attachments.indexWhere(
          (PickedAttachment e) => e.selectedMedia == file.selectedMedia);
      if (index == -1) {
        _attachments.add(file);
      }
    }
  }

  // ---- Counting helpers ----
  int _countPicked(AttachmentType type) =>
      _attachments.where((PickedAttachment a) => a.type == type).length;
  int _countOld(List<AttachmentEntity>? old, AttachmentType type) =>
      (old ?? <AttachmentEntity>[])
          .where((AttachmentEntity a) => a.type == type)
          .length;
  int totalOf(List<AttachmentEntity>? old, AttachmentType type) =>
      _countPicked(type) + _countOld(old, type);
}
