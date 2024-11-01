import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/loader.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../providers/chat_provider.dart';
import 'message_tile.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatPro =
        Provider.of<ChatProvider>(context, listen: false);

    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable:
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox)
              .listenable(),
      builder: (BuildContext context, Box<GettedMessageEntity> box, _) {
        final List<GettedMessageEntity> getted = box.values
            .where((GettedMessageEntity e) => e.chatID == chatPro.chat?.chatId)
            .toList();
        final GettedMessageEntity? last = getted.isEmpty ? null : getted.last;
        final List<MessageEntity> msgs =
            last?.sortedMessage() ?? <MessageEntity>[];
        return Expanded(
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            reverse: true,
            itemCount: msgs.length,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (BuildContext context, int index) {
              if (index == (msgs.length - 1)) {
                log('Index: $index - length: ${msgs.length} - msgs: ${msgs[index].text}');
              }
              return index == (msgs.length - 1)
                  ? FutureBuilder<bool>(
                      future: chatPro.loadMessages(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loader();
                        }
                        return MessageTile(message: msgs[index]);
                      })
                  : MessageTile(message: msgs[index]);
            },
          ),
        );
      },
    );
  }
}
