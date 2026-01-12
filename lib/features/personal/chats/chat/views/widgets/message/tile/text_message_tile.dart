import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/enums/message/message_status.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../providers/send_message_provider.dart';
import '../common/message_status_indicator.dart';
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
    final bool isMe = message.sendBy == LocalAuth.uid;
    final MessageStatus status = message.status ?? MessageStatus.sent;
    final bool isPending = status == MessageStatus.pending;
    final bool isFailed = status == MessageStatus.failed;

    // Build the message bubble content
    Widget messageBubble = MessageBgWidget(
      isMe: isMe,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
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
                  return DocumentTile(message: message);
                case AttachmentType.contacts:
                  return ContactMessageTile(attachment: attachment, isMe: isMe);
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
            Text(message.text),
        ],
      ),
    );

    // For pending/failed messages, show the sending arrow OUTSIDE the bubble
    if (isMe && (isPending || isFailed)) {
      final Widget content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Sending arrow or failed icon on the left of the bubble
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: MessageStatusIndicator(
                status: status,
                isMe: isMe,
                size: 18,
              ),
            ),
            // The message bubble (constrained)
            Flexible(child: messageBubble),
          ],
        ),
      );

      // If failed, allow tapping the message to retry sending
      if (isFailed) {
        return GestureDetector(
          onTap: () {
            final SendMessageProvider sendProvider =
                Provider.of<SendMessageProvider>(context, listen: false);
            sendProvider.retryMessage(context, message);
          },
          child: content,
        );
      }

      return content;
    }

    // For sent/delivered/read messages, show normally
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: messageBubble,
    );
  }
}
