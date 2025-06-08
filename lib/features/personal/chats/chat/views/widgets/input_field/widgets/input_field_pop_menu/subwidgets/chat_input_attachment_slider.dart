import 'package:flutter/material.dart';
import '../../../../../../../../../../core/widgets/video_widget.dart';
import '../../../../../../../../../attachment/domain/entities/picked_attachment.dart';

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
  const CustomMediaTile({required this.media, super.key});
  final PickedAttachment media;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: media.type == AttachmentType.image
            ? Image.file(
                media.file,
                fit: BoxFit.cover,
              )
            : VideoWidget(
                fit: BoxFit.cover,
                showTime: true,
                videoSource: media.file.path,
                play: false,
              ),
      ),
    );
  }
}
