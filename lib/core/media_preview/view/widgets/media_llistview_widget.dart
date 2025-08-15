import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/attachment/domain/entities/attachment_entity.dart';
import '../../../../features/attachment/domain/entities/picked_attachment.dart';
import '../../../widgets/video_widget.dart';
import '../provider/media_preview_provider.dart';

class MediaListView extends StatelessWidget {
  const MediaListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaPreviewProvider>(
      builder:
          (BuildContext context, MediaPreviewProvider provider, Widget? child) {
        final List<PickedAttachment> attachments = provider.attachments;
        if (attachments.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: attachments.length,
            itemBuilder: (BuildContext context, int index) {
              final PickedAttachment media = attachments[index];
              final bool isSelected = index == provider.currentIndex;

              return GestureDetector(
                onTap: () => provider.setCurrentIndex(index),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        border: Border.all(
                          color: isSelected
                              ? ColorScheme.of(context).secondary
                              : ColorScheme.of(context).primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: media.type == AttachmentType.video
                            ? Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  AbsorbPointer(
                                    child: VideoWidget(
                                      showTime: true,
                                      videoSource: media.file.path,
                                      play: false,
                                    ),
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
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => provider.removeAttachment(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
