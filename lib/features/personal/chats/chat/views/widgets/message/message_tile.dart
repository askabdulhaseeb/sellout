import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../providers/chat_provider.dart';
import 'tile/alert_message_tile.dart';
import 'tile/link_message_tile.dart';
import 'tile/offer_message_tile.dart';
import 'tile/quote_message_tile.dart';
import 'tile/visiting_message_tile.dart';
import 'tile/text_message_tile.dart';
import 'inquiry_message_tile.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({required this.message, required this.timeDiff, super.key});
  final MessageEntity message;
  final Duration? timeDiff;

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sendBy == LocalAuth.uid;

    return MessageType.invitationParticipant == message.type ||
            MessageType.acceptInvitation == message.type ||
            MessageType.removeParticipant == message.type ||
            MessageType.leaveGroup == message.type
        ? AlertMessageTile(message: message)
        : Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Name + timestamp above the message
              if (timeDiff != null && timeDiff!.inMinutes > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                  child: MessageSenderName(
                    senderId: message.sendBy,
                    timestamp: message.createdAt.timeOnly,
                  ),
                ),
              MessageType.none == message.type
                  ? Text(message.displayText)
                  : MessageType.text == message.type
                  ? TextMessageTile(
                      key: ValueKey<String>(
                        '${message.messageId}_${message.fileStatus ?? ""}_${message.status?.code ?? ""}',
                      ),
                      message: message,
                    )
                  : MessageType.invitationParticipant == message.type ||
                        MessageType.acceptInvitation == message.type ||
                        MessageType.removeParticipant == message.type ||
                        MessageType.leaveGroup == message.type
                  ? AlertMessageTile(message: message)
                  : MessageType.visiting == message.type
                  ? VisitingMessageTile(message: message, showButtons: false)
                  : MessageType.requestQuote == message.type
                  ? SimpleMessageTile(message: message)
                  : MessageType.quote == message.type
                  ? QuoteMessageTile(pinnedMessage: false, message: message)
                  : MessageType.offer == message.type
                  ? OfferMessageTile(message: message, showButtons: false)
                  : MessageType.simple == message.type
                  ? SimpleMessageTile(message: message)
                  : MessageType.inquiry == message.type
                  ? InquiryMessageTile(message: message)
                  : Text('${message.displayText} - ${message.type?.code.tr()}'),
            ],
          );
  }
}

/// Displays sender name and timestamp above messages.
/// Uses cached sender names from ChatProvider for performance.
class MessageSenderName extends StatelessWidget {
  const MessageSenderName({
    required this.senderId,
    required this.timestamp,
    super.key,
  });

  final String senderId;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    // Use cached sender name from provider (populated by prefetchSenderNames)
    final String? cachedName =
        context.read<ChatProvider>().getSenderName(senderId);
    final String displayName = cachedName ?? 'na'.tr();

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).disabledColor),
        children: <TextSpan>[
          TextSpan(
            text: displayName,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' • $timestamp'),
        ],
      ),
    );
  }
}
