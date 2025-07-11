import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/private_chat_dashboard_tile/private_chat_dashboard_tile.dart';
import 'tiles/product_chat_dashboard_tile.dart';

class OrderChatListWidget extends StatelessWidget {
  const OrderChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<ChatEntity> chatBox =
        Hive.box<ChatEntity>(AppStrings.localChatsBox);

    // Sort chats only once by lastMessage time
    final List<String> chatKeys = chatBox.keys.cast<String>().toList();
    chatKeys.sort((String aKey, String bKey) {
      final ChatEntity? a = chatBox.get(aKey);
      final ChatEntity? b = chatBox.get(bKey);
      final DateTime aTime =
          a?.lastMessage?.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime bTime =
          b?.lastMessage?.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return Expanded(
      child: ListView.builder(
        itemCount: chatKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final String key = chatKeys[index];
          return ValueListenableBuilder<Box<ChatEntity>>(
            valueListenable: chatBox.listenable(keys: <dynamic>[key]),
            builder: (BuildContext context, Box<ChatEntity> box, _) {
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
