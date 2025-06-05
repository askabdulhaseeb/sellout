import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';

class AttachmentMessageWidget extends StatelessWidget {
  const AttachmentMessageWidget({required this.attachments, super.key});
  final List<AttachmentEntity> attachments;

  @override
  Widget build(BuildContext context) {
    final int displayCount = attachments.length > 4 ? 4 : attachments.length;

    return GridView.builder(
      itemCount: displayCount,
      shrinkWrap: true,
      padding: const EdgeInsets.all(4), // Outer padding
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: displayCount == 1 ? 1 : 2,
        crossAxisSpacing: 8, // spacing between items
        mainAxisSpacing: 8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final AttachmentEntity attachment = attachments[index];
        final bool isLast = index == 3 && attachments.length > 4;

        Widget mediaWidget;
        if (attachment.type == AttachmentType.image) {
          mediaWidget = CustomNetworkImage(imageURL: attachment.url);
        } else if (attachment.type == AttachmentType.video) {
          mediaWidget = VideoWidget(
            videoSource: attachment.url,
            play: false,
          );
        } else {
          mediaWidget = Container(
            color: Colors.grey[200],
            child: const Center(
              child:
                  Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
            ),
          );
        }
        // "+X" overlay
        if (isLast) {
          final int remaining = attachments.length - 4;
          mediaWidget = Stack(
            fit: StackFit.expand,
            children: <Widget>[
              mediaWidget,
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // background for contrast
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: mediaWidget,
          ),
        );
      },
    );
  }
}
