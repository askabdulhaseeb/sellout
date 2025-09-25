import 'package:flutter/material.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../routes/app_linking.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message_bg_widget.dart';

class SimpleMessageTile extends StatelessWidget {
  const SimpleMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == LocalAuth.uid;
    final String text = message.text;

    final bool isLink = text.startsWith('http') || text.startsWith('https');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MessageBgWidget(
          isMe: isMe,
          child: isLink
              ? InkWell(
                  onTap: () {
                    try {
                      final Uri uri = Uri.parse(text);
                      AppNavigator().openAppLink(uri);
                    } catch (e) {
                      AppLog.error('Invalid link tapped: $text', error: e);
                    }
                  },
                  child: Text(
                    text,
                    style: const TextStyle(
                      decorationColor: Colors.blueAccent,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(text)),
    );
  }
}
