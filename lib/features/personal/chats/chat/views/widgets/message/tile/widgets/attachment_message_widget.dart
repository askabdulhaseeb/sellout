import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import 'attachment_detail_screen.dart';

class AttachmentMessageWidget extends StatelessWidget {
  const AttachmentMessageWidget({required this.attachments, super.key});

  final List<AttachmentEntity> attachments;

  @override
  Widget build(BuildContext context) {
    final int totalCount = attachments.length;

    if (totalCount == 1) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<AttachmentDetailScreen>(
                builder: (_) =>
                    AttachmentDetailScreen(attachments: attachments),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildMediaContent(attachments.first, context),
          ),
        ),
      );
    }

    // ✅ More than 1 attachment — use GridView (with max 4 items shown)
    final int displayCount = totalCount > 4 ? 4 : totalCount;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          final bool isLastVisible = index == 3 && totalCount > 4;
          final int remaining = totalCount - 4;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<AttachmentDetailScreen>(
                  builder: (_) =>
                      AttachmentDetailScreen(attachments: attachments),
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildMediaContent(attachments[index], context),
                ),
                if (isLastVisible)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '+$remaining',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
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
  }

  Widget _buildMediaContent(AttachmentEntity attachment, BuildContext context) {
    if (attachment.type == AttachmentType.image) {
      return CustomNetworkImage(
          size: 200, imageURL: attachment.url, fit: BoxFit.cover);
    } else {
      return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12)),
          child: VideoWidget(
            videoSource: attachment.url,
            play: false,
            showTime: true,
          ));
    }
  }
}
