import 'package:flutter/material.dart';

import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class AlartMessageTile extends StatelessWidget {
  const AlartMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 48),
      constraints: const BoxConstraints(
        maxWidth: 50,
        minWidth: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        message.displayText,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
