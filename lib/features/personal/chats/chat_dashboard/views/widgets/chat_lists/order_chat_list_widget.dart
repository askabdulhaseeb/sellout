import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/sources/local/local_chat.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/private_chat_dashboard_tile/private_chat_dashboard_tile.dart';
import 'tiles/product_chat_dashboard_tile.dart';

class OrderChatListWidget extends StatelessWidget {
  const OrderChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LocalChat.boxLive;

    return Expanded(
      child: ValueListenableBuilder<Box<ChatEntity>>(
        valueListenable: LocalChat.boxLive.listenable(),
        builder: (BuildContext context, Box<ChatEntity> box, _) {
          // Recompute and sort chat keys whenever the box changes
          final List<String> chatKeys = box.keys.cast<String>().toList();
          chatKeys.sort((String aKey, String bKey) {
            final ChatEntity? a = box.get(aKey);
            final ChatEntity? b = box.get(bKey);
            final DateTime aTime = a?.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final DateTime bTime = b?.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
          return ListView.builder(
            itemCount: chatKeys.length,
            itemBuilder: (BuildContext context, int index) {
              final String key = chatKeys[index];
              final ChatEntity? chat = box.get(key);
              if (chat == null ||
                  (chat.type != ChatType.private &&
                      chat.type != ChatType.product)) {
                return const SizedBox(); // Don't show invalid types
              }

              return chat.type == ChatType.private
                  ? PrivateChatDashboardTile(chat: chat)
                  : ProductChatDashboardTile(chat: chat);
            },
          );
        },
      ),
    );
  }
}
