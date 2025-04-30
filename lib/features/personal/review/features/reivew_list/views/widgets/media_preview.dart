
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (BuildContext context, ReviewProvider provider, Widget? child) {
        return provider.selectedattachment.isEmpty
            ? const SizedBox.shrink()
            : Container(
                height: 400,
                width: 300,
                margin: const EdgeInsets.all(8.0),
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.selectedattachment.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PickedAttachment media =
                        provider.selectedattachment[index];
                    return Container(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: media.type == AttachmentType.video
                            ? VideoWidget(videoSource: media.file.path)
                            : Image.file(media.file, width: 100, height: 100),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
