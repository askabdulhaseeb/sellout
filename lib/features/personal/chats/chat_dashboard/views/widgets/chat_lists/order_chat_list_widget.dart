import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/private_chat_dashboard_tile.dart';
import 'tiles/product_chat_dashboard_tile.dart';

class OrderChatListWidget extends HookWidget {
  const OrderChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<ChatEntity> chatBox =
        Hive.box<ChatEntity>(AppStrings.localChatsBox);
    // ignore: unused_local_variable
    final ValueListenable<Box<ChatEntity>> listenable =
        useListenable(chatBox.listenable());

    final List<ChatEntity> chats = chatBox.values
        .where((ChatEntity e) =>
            e.type == ChatType.private || e.type == ChatType.product)
        .toList();
    return Expanded(
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final ChatEntity chat = chats[index];
          return chat.type == ChatType.private
              ? PrivateChatDashboardTile(chat: chat)
              : ProductChatDashboardTile(chat: chat);
        },
      ),
    );
  }
}
