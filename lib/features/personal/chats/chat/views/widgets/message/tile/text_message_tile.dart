import 'package:flutter/material.dart';

import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message_bg_widget.dart';

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
            Text(
              message.displayText,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            Opacity(
              opacity: isMe ? 0.8 : 0.6,
              child: Text(
                message.createdAt.timeAgo,
                style: TextStyle(color: isMe ? Colors.white : null),
              ),
            )
          ],
        ),
      ),
    );
  }
}
