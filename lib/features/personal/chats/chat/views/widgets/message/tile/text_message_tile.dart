import 'package:flutter/material.dart';

import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message_bg_widget.dart';
import 'widgets/attachment_message_widget.dart';
import 'widgets/audio_messahe_widget.dart';

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
            message.fileUrl.isNotEmpty
                ? message.fileUrl.any(
                        (AttachmentEntity e) => e.type == AttachmentType.audio)
                    ? AudioMessaheWidget(message: message)
                    : AttachmentMessageWidget(attachments: message.fileUrl)
                : const SizedBox(),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: const TextStyle(color: Colors.black),
              ),
            Opacity(
              opacity: isMe ? 0.8 : 0.6,
              child: Text(
                message.createdAt.timeAgo,
                // style: TextStyle(color: isMe ? Colors.white : null),
              ),
            )
          ],
        ),
      ),
    );
  }
}
