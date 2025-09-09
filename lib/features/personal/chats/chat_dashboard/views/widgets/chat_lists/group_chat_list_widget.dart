import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../data/sources/local/local_chat.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import 'tiles/group_chat_dashbord_tile.dart';

class GroupChatListWidget extends StatefulWidget {
  const GroupChatListWidget({super.key});

  @override
  State<GroupChatListWidget> createState() => _GroupChatListWidgetState();
}

class _GroupChatListWidgetState extends State<GroupChatListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<Box<ChatEntity>>(
        valueListenable: LocalChat.boxLive.listenable(),
        builder: (BuildContext context, Box<ChatEntity> box, _) {
          List<ChatEntity> chats = box.values
              .where((ChatEntity e) => e.type == ChatType.group)
              .toList();
          // Sort by last message time
          chats.sort((ChatEntity a, ChatEntity b) {
            final DateTime aTime = a.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final DateTime bTime = b.lastMessage?.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });
          if (chats.isEmpty) {
            return Center(
              child: EmptyPageWidget(
                icon: CupertinoIcons.chat_bubble_2,
                childBelow: Text('no_chats_found'.tr()),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (BuildContext context, int index) => Container(
                height: 1,
                color: Theme.of(context).dividerColor,
                margin: const EdgeInsets.symmetric(vertical: 8)),
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
