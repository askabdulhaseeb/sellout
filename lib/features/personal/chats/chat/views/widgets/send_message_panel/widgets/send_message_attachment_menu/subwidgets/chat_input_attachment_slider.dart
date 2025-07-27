import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../providers/send_message_provider.dart';

class ChatAttachmentsListView extends StatelessWidget {
  const ChatAttachmentsListView({required this.attachments, super.key});
  final List<PickedAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (BuildContext context, int index) {
          final PickedAttachment attachment = attachments[index];
          return CustomMediaTile(media: attachment);
        },
      ),
    );
  }
}

class CustomMediaTile extends StatelessWidget {
  const CustomMediaTile({
    required this.media,
    super.key,
  });

  final PickedAttachment media;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: media.type == AttachmentType.image
                ? Image.file(media.file, fit: BoxFit.cover)
                : VideoWidget(
                    showTime: true,
                    videoSource: media.file.path,
                    play: false,
                  ),
          ),
        ),

        // Positioned close button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              final SendMessageProvider pro =
                  Provider.of<SendMessageProvider>(context, listen: false);
              pro.removePickedAttachment(media);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
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
    );
  }
}
