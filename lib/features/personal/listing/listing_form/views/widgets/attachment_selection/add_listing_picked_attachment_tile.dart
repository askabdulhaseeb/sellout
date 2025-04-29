import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../providers/add_listing_form_provider.dart';

class AddListingPickedAttachmentTile extends StatelessWidget {
  const AddListingPickedAttachmentTile({
    super.key,
    this.attachment,
    this.imageUrl,
  });
  final PickedAttachment? attachment;
  final AttachmentEntity? imageUrl;

  bool get isVideo {
    if (attachment != null) {
      return attachment!.type == AttachmentType.video;
    }
    if (imageUrl != null) {
      return imageUrl!.type == AttachmentType.video;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocal = attachment != null;
    final AddListingFormProvider pro = Provider.of<AddListingFormProvider>(
      context,
      listen: false,
    );
    return Padding(
      padding: const EdgeInsets.all(3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 4 / 4,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: isVideo
                    ? VideoWidget(
                        videoUrl: isLocal
                            ? attachment!.file.uri.path
                            : imageUrl?.url ?? '',
                      )
                    : isLocal
                        ? Image.file(
                            File(attachment!.file.path),
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageUrl?.url ?? '',
                            fit: BoxFit.cover,
                          ),
              ),

              // Remove Button (only for picked attachments)
              // if (isLocal)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    if (isLocal) {
                      pro.removePickedAttachment(attachment!);
                    } else {
                      pro.removeAttachmentEntity(imageUrl!);
                    }
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
