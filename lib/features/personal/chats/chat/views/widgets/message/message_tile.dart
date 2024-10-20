import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/enums/message/message_type.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'tile/alart_message_tile.dart';
import 'tile/visiting_message_tile.dart';
import 'tile/text_message_tile.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return MessageType.none == message.type
        ? TextMessageTile(message: message)
        : MessageType.text == message.type
            ? TextMessageTile(message: message)
            : MessageType.invitationParticipant == message.type ||
                    MessageType.acceptInvitation == message.type
                ? AlartMessageTile(message: message)
                : MessageType.visiting == message.type
                    ? VisitingMessageTile(message: message)
                    : Text(
                        '${message.displayText} - ${message.type?.code.tr()}');
  }
}
