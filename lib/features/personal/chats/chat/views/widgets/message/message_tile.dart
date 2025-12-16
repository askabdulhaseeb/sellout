import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../business/core/data/sources/local_business.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
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
    final bool isBusiness = message.sendBy.startsWith('BU');
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
              // 🔹 Name + timestamp above the message
              if (timeDiff != null && timeDiff!.inMinutes > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                  child: MessageSenderName(
                    senderId: message.sendBy,
                    isBusiness: isBusiness,
                    timestamp:
                        message.createdAt.timeOnly, // or your formatted time
                  ),
                ),
              MessageType.none == message.type
                  ? Text(message.displayText)
                  : MessageType.text == message.type
                  ? TextMessageTile(message: message)
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

// ...existing code...

class MessageSenderName extends StatelessWidget {
  const MessageSenderName({
    required this.senderId,
    required this.timestamp,
    super.key,
    this.isBusiness = false,
  });

  final String senderId;
  final bool isBusiness;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    if (isBusiness) {
      // Business path – typed FutureBuilder<BusinessEntity>
      return FutureBuilder<BusinessEntity?>(
        future: LocalBusiness().getBusiness(senderId),
        builder:
            (BuildContext context, AsyncSnapshot<BusinessEntity?> snapshot) {
              String displayName = 'na'.tr();
              if (snapshot.hasData && snapshot.data != null) {
                displayName = snapshot.data!.displayName ?? 'na'.tr();
              }
              return _buildRichText(context, displayName);
            },
      );
    } else {
      // User path – typed FutureBuilder<UserEntity>
      return FutureBuilder<UserEntity?>(
        future: LocalUser().user(senderId),
        initialData: LocalUser().userEntity(senderId), // cache
        builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
          String displayName = 'na'.tr();
          if (snapshot.hasData && snapshot.data != null) {
            displayName = snapshot.data!.displayName;
          }
          return _buildRichText(context, displayName);
        },
      );
    }
  }

  Widget _buildRichText(BuildContext context, String displayName) {
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
