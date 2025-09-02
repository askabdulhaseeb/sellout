import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/attachment/domain/entities/attachment_entity.dart';
import '../../../../features/attachment/domain/entities/picked_attachment.dart';
import '../../../widgets/video_widget.dart';
import '../provider/media_preview_provider.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPreviewProvider>(
      builder:
          (BuildContext context, MediaPreviewProvider provider, Widget? child) {
        final List<PickedAttachment> attachments = provider.attachments;
        if (attachments.isEmpty) return const SizedBox.shrink();
        final PickedAttachment media = attachments[provider.currentIndex];
        return Container(
          margin: const EdgeInsets.all(16),
          child: media.type == AttachmentType.video
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoWidget(
                      videoSource: media.file.path,
                      play: true,
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    media.file,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}
