import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/private_chat_dashboard_tile.dart';
import 'tiles/product_chat_dashboard_tile.dart';

class OrderChatListWidget extends StatefulWidget {
  const OrderChatListWidget({super.key});

  @override
  State<OrderChatListWidget> createState() => _OrderChatListWidgetState();
}

class _OrderChatListWidgetState extends State<OrderChatListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<ChatEntity>>(
        valueListenable:
            Hive.box<ChatEntity>(AppStrings.localChatsBox).listenable(),
        builder: (BuildContext context, Box<ChatEntity> box, _) {
          final List<ChatEntity> chats = box.values
              .where((ChatEntity e) =>
                  e.type == ChatType.private || e.type == ChatType.product)
              .toList();

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final ChatEntity chat = chats[index];
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
