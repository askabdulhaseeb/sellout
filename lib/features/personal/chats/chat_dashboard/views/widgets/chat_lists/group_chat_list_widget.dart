import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/group_chat_dashbord_tile.dart';

class GroupChatListWidget extends StatelessWidget {
  const GroupChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<ChatEntity>>(
        valueListenable:
            Hive.box<ChatEntity>(AppStrings.localChatsBox).listenable(),
        builder: (BuildContext context, Box<ChatEntity> box, _) {
          final List<ChatEntity> chats = box.values
              .where((ChatEntity e) => e.type == ChatType.group)
              .toList();
          // Sort chats by lastMessage createdAt (newest first)
          chats.sort((ChatEntity a, ChatEntity b) {
            final DateTime aTime = a.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final DateTime bTime = b.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final ChatEntity chat = chats[index];
              return GroupChatDashbordTile(chat: chat);
            },
          );
        },
      ),
    );
  }
}
