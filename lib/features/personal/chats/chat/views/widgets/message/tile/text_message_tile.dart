import 'package:flutter/material.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message_bg_widget.dart';
import 'contact_message_tile.dart';
import 'document_message_tile.dart';
import 'widgets/attachment_message_widget.dart';
import 'widgets/audio_message_widget.dart';

class TextMessageTile extends StatelessWidget {
  const TextMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    debugPrint(message.type?.code);
    final bool isMe = message.sendBy == LocalAuth.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: MessageBgWidget(
        isMe: isMe,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Handle non-image/video attachments
            if (message.fileUrl.isNotEmpty &&
                message.fileUrl.first.type != AttachmentType.image &&
                message.fileUrl.first.type != AttachmentType.video)
              ...message.fileUrl.map((AttachmentEntity attachment) {
                switch (attachment.type) {
                  case AttachmentType.audio:
                    return AudioMessageWidget(message: message);
                  case AttachmentType.document:
                    return DocumentTile(attachment: attachment, isMe: isMe);
                  case AttachmentType.contacts:
                    return ContactMessageTile(
                        attachment: attachment, isMe: isMe);
                  case AttachmentType.location:
                    return Text('📍 Location: ${attachment.originalName}');
                  default:
                    return const Text('Unknown attachment type');
                }
              }),
            // Handle image/video attachments in one widget
            if (message.fileUrl.isNotEmpty &&
                (message.fileUrl.first.type == AttachmentType.image ||
                    message.fileUrl.first.type == AttachmentType.video))
              AttachmentMessageWidget(attachments: message.fileUrl),
            // Handle text
            if (message.text.isNotEmpty || message.text == ' ')
              Text(
                message.text,
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
