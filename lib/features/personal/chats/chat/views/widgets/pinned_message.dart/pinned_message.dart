import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../message/tile/offer_message_tile.dart';
import '../message/tile/visiting_message_tile.dart';

class ChatPinnedMessage extends StatelessWidget {
  const ChatPinnedMessage({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ChatEntity>>(
      valueListenable: LocalChat.boxLive.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<ChatEntity> box, _) {
        final ChatEntity? chat = box.get(chatId);
        final bool hasPinned = chat != null && chat.pinnedMessage != null;

        return hasPinned
            ? Container(
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (chat.pinnedMessage?.offerDetail != null)
                      OfferMessageTile(
                        message: chat.pinnedMessage!,
                        showButtons: true,
                      ),
                    if (chat.pinnedMessage?.visitingDetail != null)
                      VisitingMessageTile(
                        message: chat.pinnedMessage!,
                        showButtons: true,
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
