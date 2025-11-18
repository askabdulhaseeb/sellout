import 'package:flutter/material.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';

class AlartMessageTile extends StatelessWidget {
  const AlartMessageTile({required this.message, super.key});
  final MessageEntity message;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (LocalAuth.uid == message.persons.first)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 48),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  maxLines: 4,
                  message.displayText,
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).labelSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
