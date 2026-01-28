import 'package:flutter/material.dart';
import '../../../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../../../core/widgets/media/video_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import 'attachment_detail_screen.dart';

class AttachmentMessageWidget extends StatelessWidget {
  const AttachmentMessageWidget({required this.attachments, super.key});
  final List<AttachmentEntity> attachments;

  @override
  Widget build(BuildContext context) {
    final int totalCount = attachments.length;
    if (totalCount == 1) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<AttachmentDetailScreen>(
              builder: (_) => AttachmentDetailScreen(attachments: attachments),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildMediaContent(attachments.first, context),
          ),
        ),
      );
    }
    final int displayCount = totalCount >= 4 ? 4 : totalCount;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        final bool isLastVisible = index == 3 && totalCount > 4;
        final int remaining = totalCount - 3;

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
                borderRadius: BorderRadius.circular(4),
                child: _buildMediaContent(attachments[index], context),
              ),
              if (isLastVisible)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '+$remaining',
                      style: TextTheme.of(context).titleLarge?.copyWith(
                        color: ColorScheme.of(context).onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaContent(AttachmentEntity attachment, BuildContext context) {
    if (attachment.type == AttachmentType.image) {
      return SizedBox.expand(
        child: CustomNetworkImage(imageURL: attachment.url, fit: BoxFit.cover),
      );
    } else {
      return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRect(
          child: VideoWidget(
            fit: BoxFit.cover,
            square: true,
            videoSource: attachment.url,
            play: false,
            showTime: true,
          ),
        ),
      );
    }
  }
}
