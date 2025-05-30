import 'package:flutter/material.dart';
import '../../../../features/attachment/domain/entities/picked_attachment.dart';
import '../../../../features/attachment/domain/entities/picked_attachment_option.dart';
import '../../../../features/attachment/views/screens/pickable_attachment_screen.dart';

class MediaPreviewProvider extends ChangeNotifier {
  MediaPreviewProvider(this.attachments);
  List<PickedAttachment> attachments;
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    if (index >= 0 && index < attachments.length) {
      currentIndex = index;
      notifyListeners();
    }
  }

  void setAttachments(List<PickedAttachment> newAttachments) {
    attachments
      ..clear()
      ..addAll(newAttachments);
    notifyListeners();
  }

  Future<void> setImages(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final List<PickedAttachment> selectedMedia = attachments
        .where((PickedAttachment element) => element.selectedMedia != null)
        .toList();

    final List<PickedAttachment>? files =
        await Navigator.of(context).push<List<PickedAttachment>>(
      MaterialPageRoute<List<PickedAttachment>>(builder: (_) {
        return PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 10,
            allowMultiple: true,
            type: type,
            selectedMedia: selectedMedia
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        );
      }),
    );

    if (files != null) {
      final List<PickedAttachment> updatedList =
          List<PickedAttachment>.from(attachments);
      for (final PickedAttachment file in files) {
        final bool alreadyExists = updatedList.any(
          (PickedAttachment element) =>
              element.selectedMedia == file.selectedMedia,
        );
        if (!alreadyExists) {
          updatedList.add(file);
        }
      }
      setAttachments(updatedList);
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
      if (currentIndex >= attachments.length) {
        currentIndex = attachments.isEmpty ? 0 : attachments.length - 1;
      }
      notifyListeners();
    }
  }
}
