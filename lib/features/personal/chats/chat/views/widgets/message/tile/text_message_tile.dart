import 'package:flutter/material.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message_bg_widget.dart';
import 'document_message_tile.dart';
import 'widgets/attachment_message_widget.dart';
import 'widgets/audio_message_widget.dart';
class TextMessageTile extends StatelessWidget {
  const TextMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
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
            if (message.fileUrl.isNotEmpty)
              ...message.fileUrl.map((AttachmentEntity attachment) {
                switch (attachment.type) {
                  case AttachmentType.audio:
                    return AudioMessageWidget(message: message);
                  case AttachmentType.image:
                  case AttachmentType.video:
                    return AttachmentMessageWidget(attachments: <AttachmentEntity>[attachment]);
                  case AttachmentType.document:
                    return DocumentTile(attachment: attachment,isMe: isMe);
                  case AttachmentType.contacts:
                    return Text('📞 Contact: ${attachment.originalName}');
                  case AttachmentType.location:
                    return Text('📍 Location: ${attachment.originalName}');
                  default:
                    return Text('📎 File: ${attachment.originalName}');
                }
              }).toList(),
            if (message.text.isNotEmpty ||message.text == ' ')
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
