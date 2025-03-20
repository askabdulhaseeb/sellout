
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../providers/review_provider.dart';

class MediaGridView extends StatelessWidget {
  const MediaGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ReviewProvider>(
        builder:
            (BuildContext context, ReviewProvider provider, Widget? child) {
          return provider.attachments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: provider.attachments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PickedAttachment media = provider.attachments[index];
                    final bool isSelected =
                        provider.selectedattachment.contains(media);
                    return GestureDetector(
                      onTap: () => provider.toggleMediaSelection(media),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          media.type == AttachmentType.video
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    AbsorbPointer(
                                      child: VideoWidget(
                                          videoUrl: media.file.path,
                                          play: false),
                                    ), // Video thumbnail
                                    const Icon(Icons.play_circle_fill,
                                        size: 40, color: Colors.white),
                                  ],
                                )
                              : Image.file(media.file, fit: BoxFit.cover),
                          if (isSelected)
                            Container(
                              color: Colors.black54,
                              child: const Icon(Icons.check_circle,
                                  color: Colors.white, size: 30),
                            ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
